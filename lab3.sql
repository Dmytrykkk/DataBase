-- 1. Вивести книги у яких не введена ціна або ціна дорівнює 0
SELECT * FROM tabl WHERE Price IS NULL OR Price = 0;

-- 2. Вивести книги у яких введена ціна, але не введений тираж
SELECT * FROM tabl WHERE Price IS NOT NULL AND Circulation IS NULL;

-- 3. Вивести книги, про дату видання яких нічого не відомо.
SELECT * FROM tabl WHERE Date IS NULL;

-- 4. Вивести книги, з дня видання яких пройшло не більше року.
SELECT * FROM tabl WHERE Date >= CURRENT_DATE - INTERVAL '1 year';

-- 5. Вивести список книг-новинок, відсортованих за зростанням ціни
SELECT * FROM tabl WHERE Newbie = 'Yes' ORDER BY Price ASC;

-- 6. Вивести список книг з числом сторінок від 300 до 400, відсортованих в зворотному алфавітному порядку назв
SELECT * FROM tabl WHERE Pages BETWEEN 300 AND 400 ORDER BY Name DESC;

-- 7. Вивести список книг з ціною від 20 до 40, відсортованих за спаданням дати
SELECT * FROM tabl WHERE Price BETWEEN 20 AND 40 ORDER BY Date DESC;

-- 8. Вивести список книг, відсортованих в алфавітному порядку назв і ціною по спадаючій
SELECT * FROM tabl ORDER BY Name ASC, Price DESC;

-- 9. Вивести книги, у яких ціна однієї сторінки < 10 копійок.
SELECT * FROM tabl WHERE (Price / Pages) < 0.10;

-- 10. Вивести значення наступних колонок: число символів в назві, перші 20 символів назви великими літерами
SELECT LENGTH(Name) AS name_length, UPPER(SUBSTRING(Name FROM 1 FOR 20)) AS first_20_chars FROM tabl;

-- 11. Вивести значення наступних колонок: перші 10 і останні 10 символів назви прописними буквами, розділені '...'
SELECT CONCAT(UPPER(SUBSTRING(Name FROM 1 FOR 10)), '...', UPPER(SUBSTRING(Name FROM LENGTH(Name) - 9))) AS formatted_name FROM tabl;

-- 12. Вивести значення наступних колонок: назва, дата, день, місяць, рік
SELECT Name, Date, EXTRACT(DAY FROM Date) AS day, EXTRACT(MONTH FROM Date) AS month, EXTRACT(YEAR FROM Date) AS year FROM tabl;

-- 13. Вивести значення наступних колонок: назва, дата, дата в форматі 'dd / mm / yyyy'
SELECT Name, Date, TO_CHAR(Date, 'DD/MM/YYYY') AS formatted_date FROM tabl;

-- 14. Вивести значення наступних колонок: код, ціна, ціна в грн., ціна в євро.
SELECT Cod, Price, Price * 38.42 AS price_uah, Price * 0.84 AS price_eur FROM tabl;

-- 15. Вивести значення наступних колонок: код, ціна, ціна в грн. без копійок, ціна без копійок округлена
SELECT Cod, Price, TRUNC(Price * 38.42) AS price_uah, ROUND(Price * 38.42) AS rounded_price 
FROM tabl

-- 16. Додати інформацію про нову книгу (всі колонки)
INSERT INTO tabl (Numer, Cod, Newbie, Name, Price, Publishing, Pages, Form, Date, Circulation, Topic, Category) VALUES
(300, 1234, 'No', 'New Book', 25.50, 'Publisher X', 200, '60x90/16', '2024-04-12', 1000, 'New Topic', 'New Category');

-- 17. Додати інформацію про нову книгу (колонки обов'язкові для введення)
INSERT INTO tabl (Name, Price, Pages, Date, Circulation, Topic, Category) VALUES
('Another New Book', 30.00, 250, '2024-04-12', 500, 'Another New Topic', 'Another New Category');

-- 18. Видалити книги, видані до 1990 року
DELETE FROM tabl WHERE EXTRACT(YEAR FROM Date) < 1990;

-- 19. Проставити поточну дату для тих книг, у яких дата видання відсутня
UPDATE tabl SET Date = CURRENT_DATE WHERE Date IS NULL;

-- 20. Установити ознаку новинка для книг виданих після 2005 року
UPDATE tabl SET Newbie = 'Yes' WHERE EXTRACT(YEAR FROM Date) > 2005;
