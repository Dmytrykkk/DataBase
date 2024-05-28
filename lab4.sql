-- 1. Вивести статистику: загальна кількість всіх книг, їх вартість, їх середню вартість, мінімальну і максимальну ціну
SELECT 
    COUNT(*) AS total_books,
    SUM(Price) AS total_price,
    AVG(Price) AS average_price,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price
FROM tabl;

-- 2. Вивести загальну кількість всіх книг без урахування книг з непроставленою ціною
SELECT 
	COUNT(*) AS total_with_price
FROM tabl
WHERE Price IS NOT NULL;

-- 3. Вивести статистику (див. 1) для книг новинка / не новинка
SELECT 
    Newbie,
    COUNT(*) AS total_books,
    SUM(Price) AS total_price,
    AVG(Price) AS average_price,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price
FROM tabl
GROUP BY Newbie;

-- 4. Вивести статистику (див. 1) для книг за кожним роком видання
SELECT 
    EXTRACT(YEAR FROM Date) AS publication_year,
    COUNT(*) AS total_books,
    SUM(Price) AS total_price,
    AVG(Price) AS average_price,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price
FROM tabl
WHERE Date IS NOT NULL
GROUP BY publication_year
ORDER BY publication_year;

-- 5. Змінити п.4, виключивши з статистики книги з ціною від 10 до 20
SELECT 
    EXTRACT(YEAR FROM Date) AS publication_year,
    COUNT(*) AS total_books,
    SUM(Price) AS total_price,
    AVG(Price) AS average_price,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price
FROM tabl
WHERE Date IS NOT NULL AND (Price < 10 OR Price > 20)
GROUP BY publication_year
ORDER BY publication_year;

-- 6. Змінити п.4. Відсортувати статистику по спадаючій кількості.
SELECT 
    EXTRACT(YEAR FROM Date) AS publication_year,
    COUNT(*) AS total_books,
    SUM(Price) AS total_price,
    AVG(Price) AS average_price,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price
FROM tabl
WHERE Date IS NOT NULL
GROUP BY publication_year
ORDER BY total_books DESC;

-- 7. Вивести загальну кількість кодів книг і кодів книг що не повторюються
SELECT 
    COUNT(Cod) AS total_cod,
	COUNT(DISTINCT Cod) AS unique_cod
FROM tabl;

-- 8. Вивести статистику: загальна кількість і вартість книг по першій букві її назви
SELECT 
    LEFT(Name, 1) AS first_letter,
    COUNT(Name) AS total_books,
    SUM(Price) AS total_price
FROM tabl
GROUP BY first_letter
ORDER BY first_letter;

-- 9. Змінити п. 8, виключивши з статистики назви що починаються з англ. букви або з цифри.
SELECT 
    LEFT(Name, 1) AS first_letter,
    COUNT(Name) AS total_books,
    SUM(Price) AS total_price
FROM tabl
WHERE NOT LEFT(Name, 1) ~ '[a-zA-Z0-9]'
GROUP BY first_letter
ORDER BY first_letter;

-- 10. Змінити п. 9 так щоб до складу статистики потрапили дані з роками більшими за 2000.
SELECT 
    LEFT(Name, 1) AS first_letter,
    COUNT(*) AS total_books,
    SUM(Price) AS total_price
FROM tabl
WHERE NOT LEFT(Name, 1) ~ '[a-zA-Z0-9]' AND EXTRACT(YEAR FROM Date) > 2000
GROUP BY first_letter;

-- 11. Змінити п. 10. Відсортувати статистику по спадаючій перших букв назви.
SELECT 
    LEFT(Name, 1) AS first_letter,
    COUNT(Name) AS total_books,
    SUM(Price) AS total_price
FROM tabl
WHERE NOT LEFT(Name, 1) ~ '[a-zA-Z0-9]' AND EXTRACT(YEAR FROM Date) > 2000
GROUP BY first_letter
ORDER BY first_letter DESC;
-- 12. Вивести статистику (див. 1) по кожному місяцю кожного року.

SELECT 
    EXTRACT(YEAR FROM Date) AS publication_year,
    EXTRACT(MONTH FROM Date) AS publication_month,
    COUNT(*) AS total_books,
    SUM(Price) AS total_price,
    AVG(Price) AS average_price,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price
FROM tabl
GROUP BY publication_year, publication_month
ORDER BY publication_year, publication_month;
-- 13. Змінити п. 12 так щоб до складу статистики не увійшли дані з незаповненими датами.

SELECT 
    EXTRACT(YEAR FROM Date) AS publication_year,
    EXTRACT(MONTH FROM Date) AS publication_month,
    COUNT(*) AS total_books,
    SUM(Price) AS total_price,
    AVG(Price) AS average_price,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price
FROM tabl
WHERE Date IS NOT NULL
GROUP BY publication_year, publication_month
ORDER BY publication_year, publication_month;

-- 14. Змінити п. 12. Фільтр по спадаючій року і зростанню місяця.
SELECT 
    EXTRACT(YEAR FROM Date) AS publication_year,
    EXTRACT(MONTH FROM Date) AS publication_month,
    COUNT(*) AS total_books,
    SUM(Price) AS total_price,
    AVG(Price) AS average_price,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price
FROM tabl
GROUP BY publication_year, publication_month
ORDER BY publication_year DESC, publication_month ASC;

-- 15. Вивести статистику для книг новинка / не новинка: загальна ціна, загальна ціна в грн. / Євро. Колонкам запиту дати назви за змістом.
SELECT 
	Newbie,
    SUM(Price) AS total_price,
    ROUND(SUM(Price * 38.42), 2) AS total_price_uah,
    ROUND(SUM(Price * 0.85), 2) AS total_price_eur
FROM tabl
GROUP BY Newbie;

-- 16. Змінити п. 15 так щоб виводилася округлена до цілого числа (дол. / Грн. / Євро / руб.) Ціна.
SELECT 
	Newbie,
    SUM(Price) AS total_price,
    ROUND(SUM(Price * 38.42)) AS total_price_uah,
    ROUND(SUM(Price * 0.85)) AS total_price_eur
FROM tabl
GROUP BY Newbie;
-- 17. Вивести статистику (див. 1) по видавництвах.
SELECT 
    Publishing,
    COUNT(*) AS total_books,
    SUM(Price) AS total_price,
    AVG(Price) AS average_price,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price
FROM tabl
GROUP BY Publishing;

-- 18. Вивести статистику (див. 1) за темами і видавництвами. Фільтр по видавництвам.
SELECT 
    Topic,
    Publishing,
    COUNT(*) AS total_books,
    SUM(Price) AS total_price,
    AVG(Price) AS average_price,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price
FROM tabl
GROUP BY Topic, Publishing
ORDER BY Publishing;

-- 19. Вивести статистику (див. 1) за категоріями, темами і видавництвами. Фільтр по видавництвам, темах, категоріям.
SELECT 
    Category,
    Topic,
    Publishing,
    COUNT(*) AS total_books,
    SUM(Price) AS total_price,
    AVG(Price) AS average_price,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price
FROM tabl
GROUP BY Category, Topic, Publishing
ORDER Publishing, Topic, Category;

-- 20. Вивести список видавництв, у яких округлена до цілого ціна однієї сторінки більше 10 копійок.
SELECT 
    Publishing,
	total_price,
	total_pages,
	total_price / total_pages AS coast
FROM (
    SELECT 
        Publishing,
        SUM(Price) AS total_price,
        SUM(Pages) AS total_pages
    FROM 
        tabl
    GROUP BY 
        Publishing
) AS subquery
WHERE 
    ROUND(total_price / total_pages) > 0.10;


