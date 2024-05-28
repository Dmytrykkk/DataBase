/*
a) Користувачі та їх вимоги до створюваної автоматизованої системи:
  •	Клієнти магазину, які  купують автозапчастини.
  •	Менеджери магазину, які здійснюють продажі.
  •	Постачальники, які постачають товари.
b) Документи, що циркулюють в предметній області:
  •	Рахунки від постачальників.
  •	Замовлення від клієнтів.
  •	Квитанції про оплату від клієнтів.
c) Правила, за якими формуються документи:
  •	Рахунки формуються на основі поставлених постачальником товарів.
  •	Замовлення формуються на основі запитів клієнтів на придбання товарів.
  •	Квитанції формуються під час оплати товарів.
d) Обмеження на інформацію, що повинна зберігатись в базі даних:
  •	Інформація про клієнтів 
  •	Інформація про товари 
  •	Інформація про замовлення 
Сформувати словник бази даних:
  •	Таблиця "Клієнти" (id, ПІБ, адрес, телефон(9 чисел)).
  •	Таблиця "Товари" (id, назва, модель, постачальник, ціна, кількість).
  •	Таблиця "Замовлення" (id, id_клієнта, id_товару, стан, дата).
Визначити сутності предметної області та їх атрибути:
  •	Клієнт (id, ПІБ, адреса, контактні телефон.).
  •	Товар (id, назва, модель, постачальник, ціна).
  •	Замовлення (id, id_клієнта, id_товару, дата).
Визначити зв'язки між сутностями предметної області та побудувати інфологічну модель:
  •	Кожен клієнт може мати багато замовлень (зв'язок один до багатьох).
  •	Кожен товар може бути частиною багатьох замовлень (зв'язок один до багатьох).
  •	Кожен постачальник може мати багато товарів (зв'язок один до багатьох).
*/

-- Таблиця "Клієнти"
CREATE TABLE Clients (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  address VARCHAR(100) NOT NULL,
  phone INT(9) NOT NULL
);

-- Таблиця "Постачальник"
CREATE TABLE Suppliers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- Таблиця "Товари"
CREATE TABLE Products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  model VARCHAR(100) NOT NULL,
  supplier_id INT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  quantity INT NOT NULL,
  FOREIGN KEY (supplier_id) REFERENCES Suppliers(id)
);

-- Таблиця "Замовлення"
CREATE TABLE Orders (
  id SERIAL PRIMARY KEY,
  client_id INT NOT NULL,
  product_id INT NOT NULL,
  status VARCHAR(50) NOT NULL,
  date DATE NOT NULL,
  FOREIGN KEY (client_id) REFERENCES Clients(id),
  FOREIGN KEY (product_id) REFERENCES Products(id)
);

--Створення тригера
CREATE OR REPLACE FUNCTION check_phone_length()
RETURNS TRIGGER AS $$
BEGIN
    IF LENGTH(NEW.phone::TEXT) < 9 THEN
        RAISE EXCEPTION 'Номер телефону повинен містити 9 цифр!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Прикріплення тригера до таблиці "Clients"
CREATE TRIGGER check_phone_length_trigger
BEFORE INSERT OR UPDATE ON Clients
FOR EACH ROW
EXECUTE FUNCTION check_phone_length();

-- Внесення даних в таблицю "Клієнти"
INSERT INTO Clients (full_name, address, phone) VALUES 
('Іваненко Іван Іванович', 'вул. Центральна 10', '123456789'),
('Петренко Петро Петрович', 'вул. Сонячна 5', '987654321'),
('Сидоренко Сидір Сидорович', 'вул. Зелена 7', '555666777');

-- Внесення даних в таблицю "Постачальник"
INSERT INTO Suppliers (name) VALUES 
('АвтоМотори'),
('АвтоТоп'),
('ТехноПартс'),
('СуперЗапчастини');

-- Внесення даних в таблицю "Товари"
INSERT INTO Products (name, model, supplier_id, price, quantity) VALUES 
('Двигун', 'V8', 1, 5000.00, 10),
('Паливний насос', 'Model X', 2, 800.00, 20),
('Фільтр масляний', 'EcoFilter', 3, 30.00, 50),
('Гальма', 'UltraBrake', 4, 200.00, 30);

-- Внесення даних в таблицю "Замовлення"
INSERT INTO Orders (client_id, product_id, status, date) VALUES
(1, 1, 'В обробці', '2024-05-28'),
(2, 2, 'Завершено', '2024-05-27'),
(3, 3, 'Відправлено', '2024-05-26'),
(1, 4, 'Очікує отримання', '2024-05-25');


--Виведення всіх замовлень разом інформормацією про товар та клієнта
SELECT o.id AS order_id, c.full_name AS client_name, p.name AS product_name, o.status, o.date
FROM Orders o
JOIN Clients c ON o.client_id = c.id
JOIN Products p ON o.product_id = p.id;

--Кількість товарів, що має один постачальник
SELECT s.name AS supplier_name, COUNT(p.id) AS product_count
FROM Suppliers s
LEFT JOIN Products p ON s.id = p.supplier_id
GROUP BY s.name;

--всі замовлення клієнта Іваненко Івана Івановича:
SELECT o.id AS order_id, c.full_name AS client_name, p.name AS product_name, o.status, o.date
FROM Orders o
JOIN Clients c ON o.client_id = c.id
JOIN Products p ON o.product_id = p.id
WHERE c.full_name = 'Іваненко Іван Іванович'