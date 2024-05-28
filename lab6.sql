-- 1. Вивести значення наступних колонок: назва книги, ціна, назва видавництва. Використовувати внутрішнє з'єднання, застосовуючи where.
SELECT b.Name, b.Price, p.Publishing
FROM Books AS b
INNER JOIN Publishing AS p ON b.PublishingID = p.PublishingID;

-- 2. Вивести значення наступних колонок: назва книги, назва категорії. Використовувати внутрішнє з'єднання, застосовуючи inner join.
SELECT b.Name, c.Category
FROM Books AS b
INNER JOIN Categories AS c ON b.CategoryID = c.CategoryID;

-- 3. Вивести значення наступних колонок: назва книги, ціна, назва видавництва, формат.
SELECT b.Name, b.Price, p.Publishing, b.Form
FROM Books AS b
INNER JOIN Publishing AS p ON b.PublishingID = p.PublishingID;

-- 4. Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництва. Фільтр по темам і категоріям.
SELECT t.Topic, c.Category, b.Name, p.Publishing
FROM Books AS b
INNER JOIN Topics AS t ON b.TopicID = t.TopicID
INNER JOIN Categories AS c ON b.CategoryID = c.CategoryID
INNER JOIN Publishing AS p ON b.PublishingID = p.PublishingID;

-- 5. Вивести книги видавництва 'Видавнича група BHV', видані після 2000 р.
SELECT Name
FROM Books
WHERE PublishingID = (SELECT PublishingID FROM Publishing WHERE Publishing = 'Видавнича група BHV')
AND Date > '2000-01-01';

-- 6. Вивести загальну кількість сторінок по кожній назві категорії. Фільтр по спадаючій кількості сторінок.
SELECT c.Category, SUM(b.Pages) AS TotalPages
FROM Books AS b
INNER JOIN Categories AS c ON b.CategoryID = c.CategoryID
GROUP BY c.Category
ORDER BY TotalPages DESC;

-- 7. Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.
SELECT AVG(b.Price) AS AvgPrice
FROM Books AS b
INNER JOIN Topics AS t ON b.TopicID = t.TopicID
INNER JOIN Categories AS c ON b.CategoryID = c.CategoryID
WHERE t.Topic LIKE '%Використання ПК%' AND c.Category LIKE '%Linux%';

-- 8. Вивести всі дані універсального відношення. Використовувати внутрішнє з'єднання, застосовуючи where.
SELECT
    b.*,
    p.Publishing,
    t.Topic,
    c.Category
FROM
    Books AS b
INNER JOIN Publishing AS p ON b.PublishingID = p.PublishingID
INNER JOIN Topics AS t ON b.TopicID = t.TopicID
INNER JOIN Categories AS c ON b.CategoryID = c.CategoryID;

-- 9. Вивести всі дані універсального відношення. Використовувати внутрішнє з'єднання, застосовуючи inner join.
SELECT
    b.*,
    p.Publishing,
    t.Topic,
    c.Category
FROM
    Books AS b
INNER JOIN Publishing AS p ON b.PublishingID = p.PublishingID
INNER JOIN Topics AS t ON b.TopicID = t.TopicID
INNER JOIN Categories AS c ON b.CategoryID = c.CategoryID;

-- 10. Вивести всі дані універсального відношення. Використовувати зовнішнє з'єднання, застосовуючи left join / rigth join.
SELECT
    b.*,
    p.Publishing,
    t.Topic,
    c.Category
FROM
    Books AS b
LEFT JOIN Publishing AS p ON b.PublishingID = p.PublishingID
LEFT JOIN Topics AS t ON b.TopicID = t.TopicID
LEFT JOIN Categories AS c ON b.CategoryID = c.CategoryID;

-- 11. Вивести пари книг, що мають однакову кількість сторінок. Використовувати само об’єднання і аліаси (self join).
SELECT b1.Name AS Book1, b2.Name AS Book2
FROM Books AS b1
JOIN Books AS b2 ON b1.Pages = b2.Pages AND b1.Numer < b2.Numer;

-- 12. Вивести тріади книг, що мають однакову ціну. Використовувати самооб'єднання і аліаси (self join).
SELECT
    b1.Name AS Book1,
    b2.Name AS Book2,
    b3.Name AS Book3,
    b1.Price
FROM
    Books AS b1
JOIN Books AS b2 ON b1.Price = b2.Price AND b1.Numer < b2.Numer
JOIN Books AS b3 ON b1.Price = b3.Price AND b2.Numer < b3.Numer
ORDER BY
    b1.Price, b1.Name;

-- 13. Вивести всі книги категорії 'C ++'. Використовувати підзапити (subquery).
SELECT Name FROM Books WHERE CategoryID IN (SELECT CategoryID FROM Categories WHERE Category = 'C&C++');

-- 14. Вивести книги видавництва 'BHV', видані після 2000 р. Використовувати підзапити (subquery).
SELECT Name FROM Books WHERE PublishingID = (SELECT PublishingID FROM Publishing WHERE Publishing = 'Видавнича група BHV') AND Date > '2000-01-01';

-- 15. Вивести список видавництв, у яких розмір книг перевищує 400 сторінок. Використовувати пов'язані підзапити (correlated subquery).
SELECT DISTINCT p.Publishing
FROM Publishing AS p
WHERE EXISTS (SELECT 1 FROM Books AS b WHERE b.PublishingID = p.PublishingID AND b.Pages > 400);

-- 16. Вивести список категорій в яких більше 3-х книг. Використовувати пов'язані підзапити (correlated subquery).
SELECT c.Category
FROM Categories AS c
WHERE (
    SELECT COUNT(*) FROM Books AS b WHERE b.CategoryID = c.CategoryID
) > 3;

-- 17. Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва. Використовувати exists.
SELECT Name FROM Books WHERE EXISTS (SELECT 1 FROM Publishing WHERE PublishingID = Books.PublishingID AND Publishing = 'Видавнича група BHV');

-- 18. Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва. Використовувати not exists.
SELECT Name FROM Books WHERE NOT EXISTS (SELECT 1 FROM Publishing WHERE PublishingID = Books.PublishingID AND Publishing = 'Видавнича група BHV');

-- 19. Вивести відсортований загальний список назв тем і категорій. Використовувати union.
SELECT Topic AS Description FROM Topics
UNION
SELECT Category FROM Categories
ORDER BY Description;

-- 20. Вивести відсортований в зворотному порядку загальний список перших слів, назв книг і категорій що не повторюються. Використовувати union.
SELECT FirstWord
FROM (
    SELECT DISTINCT SPLIT_PART(Name, ' ', 1) AS FirstWord FROM Books
    UNION
    SELECT DISTINCT SPLIT_PART(Category, ' ', 1) AS FirstWord FROM Categories
) AS Subquery
ORDER BY FirstWord DESC;
