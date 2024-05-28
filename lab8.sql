-- 1. Кількість тем може бути в діапазоні від 5 до 10.
CREATE OR REPLACE FUNCTION check_topic_count() RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM Topics) < 5 OR (SELECT COUNT(*) FROM Topics) > 10 THEN
        RAISE EXCEPTION 'Кількість тем може бути в діапазоні від 5 до 10';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER topic_count_trigger
AFTER INSERT OR DELETE OR UPDATE ON Topics
FOR EACH STATEMENT EXECUTE FUNCTION check_topic_count();
--INSERT INTO Topics (Topic) VALUES ('Нова тема');

-- 2. Новинкою може бути тільки книга видана в поточному році.
CREATE OR REPLACE FUNCTION check_newbie_year() RETURNS TRIGGER AS $$
DECLARE
    cod_newbie BOOLEAN;
BEGIN
    SELECT Newbie
    INTO cod_newbie
    FROM Cods
    WHERE CodID = NEW.CodID;

    IF NEW.Date IS DISTINCT FROM CURRENT_DATE AND cod_newbie THEN
        RAISE EXCEPTION 'Новинкою може бути тільки книга видана в поточному році';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER newbie_check_trigger
BEFORE INSERT OR UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION check_newbie_year();
/*
UPDATE Books
SET Date = CURRENT_DATE - INTERVAL '2 year'
WHERE CodID IN (SELECT CodID FROM Cods WHERE Newbie = TRUE);
*/

-- 3. Книга з кількістю сторінок до 100 не може коштувати більше 10 $, до 200 - 20 $, до 300 - 30 $.
CREATE OR REPLACE FUNCTION check_page_price() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Pages <= 100 AND NEW.Price > 10 THEN
        RAISE EXCEPTION 'Книга до 100 сторінок не може коштувати більше $10';
    ELSIF NEW.Pages <= 200 AND NEW.Price > 20 THEN
        RAISE EXCEPTION 'Книга до 200 сторінок не може коштувати більше $20';
    ELSIF NEW.Pages <= 300 AND NEW.Price > 30 THEN
        RAISE EXCEPTION 'Книга до 300 сторінок не може коштувати більше $30';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER page_price_trigger
BEFORE INSERT OR UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION check_page_price();

--UPDATE Books SET Price = 35 WHERE pages <= 200

-- 4. Видавництво "BHV" не випускає книги накладом меншим 5000, а видавництво Diasoft - 10000.
CREATE OR REPLACE FUNCTION check_circulation() RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.PublishingID = (SELECT PublishingID FROM Publishing WHERE Publishing = 'Видавнича група BHV') AND NEW.Circulation < 5000) THEN
        RAISE EXCEPTION 'Книга видавництва BHV повинна мати наклад не менше 5000 примірників';
    ELSIF (NEW.PublishingID = (SELECT PublishingID FROM Publishing WHERE Publishing = 'Diasoft') AND NEW.Circulation < 10000) THEN
        RAISE EXCEPTION 'Книга видавництва Diasoft повинна мати наклад не менше 10000 примірників';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER circulation_trigger
BEFORE INSERT OR UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION check_circulation();

/*
UPDATE Books 
SET Circulation = 35 
WHERE PublishingID = (SELECT PublishingID FROM Publishing WHERE Publishing = 'Видавнича група BHV');
*/

-- 5. Книги з однаковим кодом повинні мати однакові дані.
CREATE OR REPLACE FUNCTION check_duplicate_cod() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Books WHERE CodID = NEW.CodID AND Numer <> NEW.Numer) THEN
        RAISE EXCEPTION 'Книга з таким кодом вже існує';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER duplicate_cod_trigger
BEFORE INSERT OR UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION check_duplicate_cod();

/*
INSERT INTO Books (Numer, CodID, Name, Price, PublishingID, Pages, Date, Circulation, TopicID, CategoryID) VALUES
(100, 1, 'Книга', 10.00, 1, 100, '2023-01-01', 5000, 1, 1);
*/

-- 6. При спробі видалення книги видається інформація про кількість видалених рядків. Якщо користувач не "dbo", то видалення забороняється.
CREATE OR REPLACE FUNCTION delete_book_info() RETURNS TRIGGER AS $$
BEGIN
    IF (CURRENT_USER <> 'dbo') THEN
        RAISE EXCEPTION 'Видалення книги заборонено для даного користувача';
    ELSE
        RAISE NOTICE 'Кількість видалених рядків: %', FOUND_ROWS();
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_book_trigger
AFTER DELETE ON Books
FOR EACH STATEMENT EXECUTE FUNCTION delete_book_info();

-- 7. Користувач "dbo" не має права змінювати ціну книги.
CREATE OR REPLACE FUNCTION check_price_change() RETURNS TRIGGER AS $$
BEGIN
    IF (CURRENT_USER = 'dbo' AND OLD.Price <> NEW.Price) THEN
        RAISE EXCEPTION 'Зміна ціни книги заборонена для даного користувача';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER price_change_trigger
BEFORE UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION check_price_change();

--DELETE FROM Books WHERE Numer = 2;

-- 8. Видавництва ДМК і Еком підручники не видають.
CREATE OR REPLACE FUNCTION check_publishing() RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.PublishingID IN (SELECT PublishingID FROM Publishing WHERE Publishing IN ('ДМК', 'Эком')) AND NEW.CategoryID = (SELECT CategoryID FROM Categories WHERE Category = 'Підручники')) THEN
        RAISE EXCEPTION 'Видавництва ДМК і Еком підручники не видають';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER publishing_trigger
BEFORE INSERT OR UPDATE ON Books
FOR EACH ROW EXECUTE FUNCTION check_publishing();

/*
UPDATE Books 
SET CategoryID = (SELECT CategoryID FROM Categories WHERE Category = 'Підручники') 
WHERE PublishingID IN (SELECT PublishingID FROM Publishing WHERE Publishing IN ('ДМК', 'Эком'));
*/

-- 9. Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року.
CREATE OR REPLACE FUNCTION check_newbie_count() RETURNS TRIGGER AS $$
DECLARE
    newbie_month_count INT;
BEGIN
    SELECT COUNT(*)
    INTO newbie_month_count
    FROM Books b
    JOIN Cods c ON b.CodID = c.CodID
    WHERE c.Newbie = TRUE
    AND EXTRACT(MONTH FROM b.Date) = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(YEAR FROM b.Date) = EXTRACT(YEAR FROM CURRENT_DATE);
    
    IF (newbie_month_count >= 10) THEN
        RAISE EXCEPTION 'Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER newbie_count_trigger
BEFORE INSERT ON Books
FOR EACH ROW EXECUTE FUNCTION check_newbie_count();
/*
INSERT INTO Books (Numer, CodID, Name, Price, PublishingID, Pages, Date, Circulation, TopicID, CategoryID, Form) VALUES
(109, 123, 'Книга1', 10.00, 9, 100, CURRENT_DATE, 5000, 1, 1, '60х88 / 16');
*/



-- 10. Видавництво BHV не випускає книги формату 60х88 / 16.
CREATE OR REPLACE FUNCTION check_bhv_format() RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.PublishingID = (SELECT PublishingID FROM Publishing WHERE Publishing = 'Видавнича група BHV') AND NEW.Form = '60х88/16') THEN
        RAISE EXCEPTION 'Видавництво BHV не випускає книги формату 60х88/16';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER bhv_format_trigger
BEFORE INSERT ON Books
FOR EACH ROW EXECUTE FUNCTION check_bhv_format();

/*
UPDATE Books 
SET Form = '60х88/16' 
WHERE PublishingID = (SELECT PublishingID FROM Publishing WHERE Publishing = 'Видавнича група BHV');
*/