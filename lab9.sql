--1. Розробити та перевірити скалярну (scalar) функцію, що повертає загальну вартість книг виданих в певному році.

CREATE OR REPLACE FUNCTION total_book_cost(year INT) RETURNS NUMERIC AS $$
DECLARE
    total_cost NUMERIC := 0;
BEGIN
    SELECT SUM(Price) INTO total_cost
    FROM Books
    WHERE EXTRACT(YEAR FROM Date) = year;
    
    RETURN total_cost;
END;
$$ LANGUAGE plpgsql;

--2. Розробити і перевірити табличну (inline) функцію, яка повертає список книг виданих в певному році

CREATE OR REPLACE FUNCTION books_published_in_year(year INT) RETURNS TABLE (
    Numer INT,
    Name VARCHAR(100),
    Price NUMERIC,
    Publishing VARCHAR(100),
    Pages INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT Numer, Name, Price, Publishing, Pages
    FROM Books
    WHERE EXTRACT(YEAR FROM Date) = year;
END;
$$ LANGUAGE plpgsql;

--3.

CREATE OR REPLACE FUNCTION numbered_publishers(publishers_list TEXT) 
RETURNS TEXT[][] AS $$
DECLARE
    publishers_array TEXT[];
    result_array TEXT[][] := '{}';
BEGIN
    publishers_array := string_to_array(publishers_list, ';');
    
    FOR i IN 1..array_length(publishers_array, 1) LOOP
        result_array := array_append(result_array, ARRAY[i::TEXT, publishers_array[i]]);
    END LOOP;
    
    RETURN result_array;
END;
$$ LANGUAGE plpgsql;

--4. Виконати набір операцій по роботі з SQL курсором: оголосити курсор;
--a. використовувати змінну для оголошення курсору;
DECLARE book_cursor CURSOR FOR
SELECT Name FROM UniversalRelation;
--b. відкрити курсор;
OPEN book_cursor;
--c. переприсвоїти курсор іншої змінної;
FETCH cursor_name INTO @book_name;
--d. виконати вибірку даних з курсору;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @book_name;

    FETCH cursor_name INTO @book_name;
END
--e. закрити курсор;
CLOSE cursor_name;
DEALLOCATE cursor_name;

--5. звільнити курсор. Розробити курсор для виводу списка книг виданих у визначеному році
DECLARE @year INT;
DECLARE @book_name VARCHAR(100);

DECLARE book_cursor CURSOR FOR
SELECT b.Name
FROM Books b
WHERE YEAR(b.Date) = @year;

SET @year = 2000;
OPEN book_cursor;
FETCH NEXT FROM book_cursor INTO @book_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @book_name;
    FETCH NEXT FROM book_cursor INTO @book_name;
END

CLOSE book_cursor;
DEALLOCATE book_cursor;