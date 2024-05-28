-- Створення таблиці Publishing
CREATE TABLE Publishing (
  PublishingID SERIAL PRIMARY KEY,
  Publishing VARCHAR(100) NOT NULL
);

-- Створення таблиці Categories
CREATE TABLE Categories (
  CategoryID SERIAL PRIMARY KEY,
  Category VARCHAR(100) NOT NULL
);

-- Створення таблиці Topics
CREATE TABLE Topics (
  TopicID SERIAL PRIMARY KEY,
  Topic VARCHAR(100) NOT NULL
);

-- Створення таблиці Cods
CREATE TABLE Cods (
  CodID SERIAL PRIMARY KEY,
  Cod INT NOT NULL,
  Newbie BOOL NOT NULL,
  UNIQUE (Cod)
);

-- Створення таблиці Books
CREATE TABLE Books (
  Numer INT PRIMARY KEY,
  CodID INT NOT NULL,
  Name VARCHAR(100) NOT NULL,
  Price NUMERIC DEFAULT NULL,
  PublishingID INT NOT NULL,
  Pages INT NOT NULL,
  Form VARCHAR(12) DEFAULT NULL,
  Date DATE DEFAULT NULL,
  Circulation INT NOT NULL,
  TopicID INT NOT NULL,
  CategoryID INT NOT NULL,
  FOREIGN KEY (PublishingID) REFERENCES Publishing (PublishingID) ON DELETE CASCADE,
  FOREIGN KEY (TopicID) REFERENCES Topics (TopicID) ON DELETE CASCADE,
  FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID) ON DELETE CASCADE,
  FOREIGN KEY (CodID) REFERENCES Cods (CodID) ON DELETE CASCADE
);

-- Внесення даних в таблицю Publishing
INSERT INTO Publishing (Publishing) VALUES 
('Видавнича група BHV'),
('Вільямс'),
('МикроАрт'),
('DiaSoft'),
('ДМК'),
('Триумф'),
('Эком'),
('Києво-Могилянська академія'),
('Університет "Україна"'),
('Вінниця: ВДТУ');

-- Внесення даних в таблицю Categories
INSERT INTO Categories (Category) VALUES 
('Підручники'),
('Апаратні засоби ПК'),
('Захист і безпека ПК'),
('Інші книги'),
('Windows 2000'),
('Linux'),
('Unix'),
('Інші операційні системи'),
('SQL'),
('C&C++');

-- Внесення даних в таблицю Topics
INSERT INTO Topics (Topic) VALUES 
('Використання ПК в цілому'),
('Операційні системи'),
('Програмування');

-- Внесення даних в таблицю Cods
INSERT INTO Cods (Cod, Newbie) VALUES 
(5110, 'No'),
(4985, 'No'),
(5141, 'No'),
(5127, 'No'),
(5199, 'No'),
(3851, 'No'),
(3932, 'No'),
(4713, 'No'),
(5217, 'No'),
(4829, 'No'),
(5170, 'No'),
(860, 'No'),
(44, 'No'),
(5176, 'No'),
(5462, 'No'),
(4982, 'No'),
(4687, 'No'),
(235, 'No'),
(8746, 'Yes'),
(2154, 'Yes'),
(2662, 'No'),
(5641, 'Yes');

-- Внесення даних в таблицю Books
INSERT INTO Books (Numer, CodID, Name, Price, PublishingID, Pages, Form, Date, Circulation, TopicID, CategoryID) VALUES
(2, 1, 'Апаратні засоби мультимедіа.Відеосистема PC', 15.51, 1, 400, '70х100/16', '2000-07-24', 5000, 1, 1),
(8, 2, 'Засвой самостійно модернізацію та ремонт ПК за 24 години, 2-ге вид.', 18.90, 2, 288, '70х100/16', '2000-07-07', 5000, 1, 1),
(9, 3, 'Структури даних та алгоритми', 37.80, 2, 384, '70х100/16', '2000-09-29', 5000, 1, 1),
(20, 4, 'Автоматизація інженерно-графічних робіт', 11.58, 1, 256, '70х100/16', '2000-06-15', 5000, 1, 1),
(31, 1, 'Апаратні засоби мультимедіа.Відеосистема PC', 15.51, 1, 400, '70х100/16', '2000-07-24', 5000, 1, 2),
(46, 5, 'Залізо IBM 2001', 30.07, 3, 368, '70х100/16', '2000-02-12', 5000, 1, 2),
(50, 6, 'Захист інформації та безпека комп"ютерних систем', 26.00, 4, 480, '84х108/16', '2000-07-24', 5000, 1, 3),
(58, 7, 'Як перетворити персональний комп"ютер на вимірювальний комплекс', 7.65, 5, 144, '60х88/16', '1999-09-26', 5000, 1, 4),
(59, 8, 'Plug-ins. Додаткові програми для музичних програм', 11.41, 5, 144, '70х100/16', '2000-02-22', 5000, 1, 4),
(175, 9, 'Windows ME. Найновіші версії програм', 16.57, 6, 320, '70х100/16', '2000-08-25', 5000, 2, 5),
(176, 10, 'Windows 2000 Professional крок за кроком з CD', 27.25, 7, 320, '70х100/16', '2000-04-28', 5000, 2, 5),
(188, 11, 'Linux версії', 24.43, 5, 346, '70х100/16', '2000-09-29', 5000, 2, 6),
(191, 12, 'Операційна система UNIX', 3.50, 1, 395, '84х100/16', '1997-05-05', 5000, 2, 7),
(203, 13, 'Відповіді на актуальні запитання щодо OS/2 Warp', 5.00, 4, 352, '60х84/16', '1996-03-20', 5000, 2, 8),
(206, 14, 'Windows ME. Супутник користувача', 12.76, 1, 306, '', '2000-10-10', 5000, 2, 8),
(209, 15, 'Мова програмування С++. Лекції та вправи', 29.00, 4, 656, '84х108/16', '2000-12-12', 5000, 3, 10),
(210, 16, 'Мова програмування С. Лекції та вправи', 29.00, 4, 432, '84х108/16', '2000-07-12', 5000, 3, 10),
(220, 17, 'Ефективне використання C++ .50 рекомендацій щодо покращення ваших програм та проектів', 17.60, 5, 240, '70х100/16', '2000-02-03', 5000, 3, 10),
(222, 18, 'Інформаційні системи і структури даних', NULL, 8, 288, '60х90/16', NULL, 400, 1, 4),
(225, 19, 'Бази даних в інформаційних системах', NULL, 9, 418, '60х84/16', '2018-07-25', 100, 3, 10),
(226, 20, 'Сервер на основі операційної системи FreeBSD 6.1', 0, 9, 216, '60х84/16', '2015-11-03', 500, 3, 8),
(245, 21, 'Організація баз даних та знань', 0, 10, 208, '60х90/16', '2001-10-10', 1000, 3, 10),
(247, 22, 'Організація баз даних та знань', 0, 1, 384, '70х100/16', '2018-07-25', 5000, 3, 10);

--Створення уневерсального відношення
CREATE VIEW UniversalRelation AS
SELECT
  b.Numer,
  c.Cod,
  c.Newbie,
  b.Name,
  b.Price,
  p.Publishing,
  b.Pages,
  b.Form,
  b.Date,
  b.Circulation,
  t.Topic,
  cat.Category
FROM
  Books b
JOIN
  Cods c ON b.CodID = c.CodID
JOIN
  Publishing p ON b.PublishingID = p.PublishingID
JOIN
  Topics t ON b.TopicID = t.TopicID
JOIN
  Categories cat ON b.CategoryID = cat.CategoryID;