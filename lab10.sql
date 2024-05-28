/*
CREATE DOMAIN student_grade AS SMALLINT
    CHECK(VALUE BETWEEN 1 AND 5) DEFAULT 3;
*/
--1. Створити користувальницький тип даних для зберігання оцінки учня на основі стандартного типу tinyint з можливістю використання порожніх значень.
CREATE TYPE student_grade AS (grade smallint);

--2. Створити об'єкт-замовчування (default) зі значенням 3.
CREATE OR REPLACE FUNCTION default_grade()
RETURNS student_grade AS $$
BEGIN
    RETURN (3)::student_grade;
END;
$$ LANGUAGE plpgsql;

-- Створити таблицю "Успішність студента", використовуючи новий тип даних. У таблиці повинні бути оцінки студента з кількох предметів
CREATE TABLE student_grades (
    subject_id SERIAL PRIMARY KEY,
    subject_name TEXT NOT NULL,
    grade student_grade DEFAULT default_grade() NOT NULL
);

--3. Зв'язати об'єкт-замовчування з призначеним для користувача типом даних для оцінки.
ALTER TABLE student_grades
ALTER COLUMN grade SET DEFAULT default_grade();

--4. Отримати інформацію про призначений для користувача тип даних
SELECT 
    typname,     -- Ім'я типу даних
    typnamespace, -- Простір імен, в якому знаходиться тип
    typowner,     -- Власник типу
    typlen,       -- Довжина типу в байтах
    typbyval,     -- Показує, чи передається значення типу за значенням (TRUE) чи посиланням (FALSE)
    typtype,      -- Тип типу (наприклад, базовий, перерахувальний, складений тощо)
    typcategory   -- Категорія типу (якщо це примітивний тип)
FROM 
    pg_type
WHERE 
    typname = 'student_grade';

-- 5. Створити об'єкт-правило (rule): a >= 1 і a <= 5 і зв'язати його з призначеним для користувача типом даних для оцінки.
CREATE OR REPLACE FUNCTION check_grade()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.grade).grade < 1 OR (NEW.grade).grade > 5 THEN
        RAISE EXCEPTION 'Оцінка повинна бути в діапазоні від 1 до 5';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER check_grade_trigger
BEFORE INSERT OR UPDATE ON student_grades
FOR EACH ROW EXECUTE FUNCTION check_grade();

--INSERT INTO student_grades (subject_name, grade) VALUES ('Укр мова', ROW(5));
--INSERT INTO student_grades (subject_name, grade) VALUES ('Філософія', ROW(6));


-- 7. Скасувати всі прив'язки і видалити з бази даних тип даних користувача, замовчування і правило.
/*
DROP TYPE student_grade CASCADE;
DROP FUNCTION check_grade() CASCADE; 
*/
-- Спочатку необхідно видалити тригер
DROP TRIGGER check_grade_triger ON student_grades;
DROP FUNCTION check_grade();
DROP TABLE student_grade;
DROP FUNCTION default_grade();
DROP TYPE student_grade;
