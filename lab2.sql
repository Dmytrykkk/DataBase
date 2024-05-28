-- 1. Вивести значення наступних колонок: номер, код, новинка, назва, ціна, сторінки
SELECT Numer, Cod, Newbie, Name, Price, Pages FROM tabl;

-- 2. Вивести значення всіх колонок
SELECT * FROM tabl;

-- 3. Вивести значення колонок в наступному порядку: код, назва, новинка, сторінки, ціна, номер
SELECT Cod, Name, Newbie, Pages, Price, Numer FROM tabl;

-- 4. Вивести значення всіх колонок 10 перших рядків
SELECT * FROM tabl LIMIT 10;

-- 5. Вивести значення всіх колонок 10% перших рядків
SELECT * FROM tabl ORDER BY Cod LIMIT  CEIL((SELECT COUNT(*) * 0.1 FROM tabl));

-- 6. Вивести значення колонки код без повторення однакових кодів
SELECT DISTINCT Cod FROM tabl;

-- 7. Вивести всі книги новинки
SELECT * FROM tabl WHERE Newbie = 'Yes';

-- 8. Вивести всі книги новинки з ціною від 20 до 30
SELECT * FROM tabl WHERE Newbie = 'Yes' AND Price BETWEEN '20' AND '30';

-- 9. Вивести всі книги новинки з ціною менше 20 і більше 30
SELECT * FROM tabl WHERE Newbie = 'Yes' AND (Price < '20' OR Price > '30');

-- 10. Вивести всі книги з кількістю сторінок від 300 до 400 і з ціною більше 20 і менше 30
SELECT * FROM tabl WHERE Pages BETWEEN 300 AND 400 AND Price BETWEEN '20' AND '30';

-- 11. Вивести всі книги видані взимку 2000 року
SELECT * FROM tabl WHERE EXTRACT(MONTH FROM Date) IN (12, 1, 2) AND EXTRACT(YEAR FROM Date) = 2000;

-- 12. Вивести книги зі значеннями кодів 5110, 5141, 4985, 4241
SELECT * FROM tabl WHERE Cod IN (5110, 5141, 4985, 4241);

-- 13. Вивести книги видані в 1999, 2001, 2003, 2005 р
SELECT * FROM tabl WHERE EXTRACT(YEAR FROM Date) IN (1999, 2001, 2003, 2005);

-- 14. Вивести книги назви яких починаються на літери А-К
SELECT * FROM tabl WHERE Name >= 'А' AND Name <= 'К';

-- 15. Вивести книги назви яких починаються на літери "АПП", видані в 2000 році з ціною до 20
SELECT * FROM tabl WHERE Name ILIKE 'АПП%' AND EXTRACT(YEAR FROM Date) = 2000 AND Price < '20';

-- 16. Вивести книги назви яких починаються на літери "АПП", закінчуються на "е", видані в першій половині 2000 року
SELECT * FROM tabl WHERE Name ILIKE 'АПП%' AND Name LIKE '%е' AND EXTRACT(YEAR FROM Date) = 2000 AND EXTRACT(MONTH FROM Date) BETWEEN 1 AND 6;

-- 17. Вивести книги, в назвах яких є слово Microsoft, але немає слова Windows
SELECT * FROM tabl WHERE Name ILIKE '%Microsoft%' AND Name NOT ILIKE '%Windows%';

-- 18. Вивести книги, в назвах яких присутня як мінімум одна цифра.
SELECT * FROM tabl WHERE Name ~ '\d';

-- 19. Вивести книги, в назвах яких присутні не менше трьох цифр.
SELECT * FROM tabl WHERE REGEXP_COUNT(Name, '\d') >= 3;
--
SELECT Name
FROM tabl
WHERE Name ~ '\d\d\d';

-- 20. Вивести книги, в назвах яких присутній рівно п'ять цифр
SELECT * FROM tabl WHERE REGEXP_COUNT(Name, '\d') = 5;
