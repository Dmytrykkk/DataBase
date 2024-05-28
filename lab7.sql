-- 1. Вивести значення наступних колонок: назва книги, ціна, назва видавництва, формат.
CREATE OR REPLACE PROCEDURE get_books_info()
LANGUAGE SQL
AS $$
    SELECT 
        b.Name, 
        b.Price, 
        p.Publishing, 
        b.Form
    FROM 
        Books AS b
    JOIN 
        Publishing AS p ON b.PublishingID = p.PublishingID;
$$; 

-- 2. Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництва. Фільтр по темам і категоріям.
CREATE OR REPLACE PROCEDURE get_books_by_topic_and_category(IN topic TEXT, IN category TEXT)
LANGUAGE SQL
AS $$
    SELECT 
        t.Topic, 
        cat.Category, 
        b.Name, 
        p.Publishing
    FROM 
        Books AS b
    JOIN 
        Topics AS t ON b.TopicID = t.TopicID
    JOIN 
        Categories AS cat ON b.CategoryID = cat.CategoryID
    JOIN 
        Publishing AS p ON b.PublishingID = p.PublishingID
    WHERE 
        t.Topic = topic AND cat.Category = category;
$$;

-- 3. Вивести книги видавництва 'BHV', видані після 2000 р.
CREATE OR REPLACE PROCEDURE get_books_after_2000_from_bhv()
LANGUAGE SQL
AS $$
    SELECT 
        b.Name, 
        b.Date
    FROM 
        Books AS b
    JOIN 
        Publishing AS p ON b.PublishingID = p.PublishingID
    WHERE 
        p.Publishing = 'Видавнича група BHV' AND b.Date > '2000-01-01';
$$;

-- 4. Вивести загальну кількість сторінок по кожній назві категорії. Фільтр по спадаючій / зростанню кількості сторінок.
CREATE OR REPLACE FUNCTION get_total_pages_by_category()
RETURNS TABLE (
    Category TEXT,
    TotalPages INT
) AS $$
DECLARE
    category_record RECORD;
BEGIN
    FOR category_record IN
        SELECT cat.Category, SUM(b.Pages) AS TotalPages
        FROM Books AS b
        JOIN Categories AS cat ON b.CategoryID = cat.CategoryID
        GROUP BY cat.Category
    LOOP
        RETURN NEXT category_record;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


-- 5. Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.
CREATE OR REPLACE FUNCTION get_avg_price_by_topic_and_category()
RETURNS NUMERIC AS $$
DECLARE
    avg_price NUMERIC;
BEGIN
    SELECT AVG(b.Price)
    INTO avg_price
    FROM Books AS b
    JOIN Topics AS t ON b.TopicID = t.TopicID
    JOIN Categories AS cat ON b.CategoryID = cat.CategoryID
    WHERE t.Topic = 'Використання ПК в цілому' AND cat.Category = 'Linux';
    RETURN avg_price;
END;
$$ LANGUAGE plpgsql;

-- 6. Вивести всі дані універсального відношення.
CREATE OR REPLACE PROCEDURE get_universal_relation()
LANGUAGE SQL
AS $$
    SELECT * FROM UniversalRelation;
$$;

-- 7. Вивести пари книг, що мають однакову кількість сторінок.
CREATE OR REPLACE PROCEDURE get_books_with_same_pages()
LANGUAGE SQL
AS $$
    SELECT 
        b1.Name AS FirstBookName, 
        b2.Name AS SecondBookName, 
        b1.Pages
    FROM 
        Books AS b1, 
        Books AS b2
    WHERE 
        b1.Numer < b2.Numer 
        AND b1.Pages = b2.Pages;
$$;

-- 8. Вивести тріади книг, що мають однакову ціну.
CREATE OR REPLACE PROCEDURE get_books_with_same_price()
LANGUAGE SQL
AS $$
    SELECT 
        b1.Name AS FirstBookName, 
        b2.Name AS SecondBookName, 
        b3.Name AS ThirdBookName, 
        b1.Price
    FROM 
        Books AS b1, 
        Books AS b2, 
        Books AS b3
    WHERE 
        b1.Numer < b2.Numer 
        AND b2.Numer < b3.Numer 
        AND b1.Price = b2.Price 
        AND b2.Price = b3.Price;
$$;

-- 9. Вивести всі книги категорії 'C++'.
CREATE OR REPLACE PROCEDURE get_books_by_category_cpp()
LANGUAGE SQL
AS $$
    SELECT 
        b.Name, 
        cat.Category
    FROM 
        Books AS b
    JOIN 
        Categories AS cat ON b.CategoryID = cat.CategoryID
    WHERE 
        cat.Category = 'C&C++';
$$;

-- 10. Вивести список видавництв, у яких розмір книг перевищує 400 сторінок.
CREATE OR REPLACE PROCEDURE get_publishers_with_large_books()
LANGUAGE SQL
AS $$
    SELECT DISTINCT p.Publishing
    FROM Publishing AS p
    JOIN Books AS b ON p.PublishingID = b.PublishingID
    WHERE b.Pages > 400;
$$;

-- 11. Вивести список категорій за якими більше 3-х книг.
CREATE OR REPLACE PROCEDURE get_categories_with_multiple_books()
LANGUAGE SQL
AS $$
    SELECT cat.Category, COUNT(b.Numer) AS BookCount
    FROM Categories AS cat
    JOIN Books AS b ON cat.CategoryID = b.CategoryID
    GROUP BY cat.Category
    HAVING COUNT(b.Numer) > 3;
$$;

-- 12. Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва.
CREATE OR REPLACE PROCEDURE get_books_if_bhv_exists()
LANGUAGE plpgsql
AS $$
DECLARE 
    bhv_exists INT;
BEGIN
    SELECT COUNT(*)
    INTO bhv_exists
    FROM Books AS b
    JOIN Publishing AS p ON b.PublishingID = p.PublishingID
    WHERE p.Publishing = 'Видавнича група BHV';
    
    IF bhv_exists > 0 THEN
        RAISE NOTICE 'Книги видавництва BHV:';
        RETURN QUERY
        SELECT b.Name
        FROM Books AS b
        JOIN Publishing AS p ON b.PublishingID = p.PublishingID
        WHERE p.Publishing = 'Видавнича група BHV';
    ELSE
        RAISE NOTICE 'Жодної книги видавництва BHV не знайдено';
    END IF;
END;
$$;

-- 13. Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва.
CREATE OR REPLACE PROCEDURE check_bhv_books()
LANGUAGE plpgsql
AS $$
DECLARE 
    bhv_exists INT;
BEGIN
    SELECT COUNT(*)
    INTO bhv_exists
    FROM Books AS b
    JOIN Publishing AS p ON b.PublishingID = p.PublishingID
    WHERE p.Publishing = 'Видавнича група BHV';
    
    IF bhv_exists = 0 THEN
        RAISE NOTICE 'Жодної книги видавництва BHV не знайдено';
    ELSE
        RAISE NOTICE 'У видавництві BHV є книги';
    END IF;
END;
$$;

-- 14. Вивести відсортоване загальний список назв тем і категорій.
CREATE OR REPLACE PROCEDURE get_sorted_themes_and_categories()
LANGUAGE SQL
AS $$
    SELECT Description FROM (
        SELECT Topic AS Description FROM Topics
        UNION
        SELECT Category AS Description FROM Categories
    ) AS combined
    ORDER BY Description;
$$;

-- 15. Вивести відсортований в зворотному порядку загальний список перших слів назв книг і категорій що не повторюються.
CREATE OR REPLACE PROCEDURE get_sorted_first_words()
LANGUAGE SQL
AS $$
    SELECT FirstWord FROM (
        SELECT DISTINCT SPLIT_PART(b.Name, ' ', 1) AS FirstWord
        FROM Books AS b
        UNION
        SELECT DISTINCT SPLIT_PART(cat.Category, ' ', 1) AS FirstWord
        FROM Categories AS cat
    ) AS combined
    ORDER BY FirstWord DESC;
$$;
