-- Создать таблицу fine
CREATE TABLE fine(
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8, 2),
    date_violation DATE,
    date_payment DATE);


-- В таблицу fine первые 5 строк уже занесены. Добавить в таблицу записи с ключевыми значениями 6, 7, 8.
INSERT INTO fine(name, number_plate, violation, sum_fine, date_violation, date_payment)
VALUES
    ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', NULL, '2020-02-14', NULL),
    ('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', NULL, '2020-02-23', NULL),
    ('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', NULL, '2020-03-03', NULL);

SELECT * FROM fine;


-- Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы traffic_violation. 
-- При этом суммы заносить только в пустые поля столбца  sum_fine.
UPDATE fine AS f 
SET f.sum_fine = (SELECT tv.sum_fine
                  FROM traffic_violation AS tv
                  WHERE tv.violation = f.violation)
WHERE f.sum_fine IS NULL;

SELECT * FROM fine;


-- Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же правило два и более раз. 
-- При этом учитывать все нарушения, независимо от того оплачены они или нет. Информацию отсортировать в алфавитном порядке, сначала 
-- по фамилии водителя, потом по номеру машины и, наконец, по нарушению.
SELECT name, number_plate, violation 
FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(violation) >= 2
ORDER BY name, number_plate, violation;


-- В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей. 
CREATE TABLE temp AS
SELECT name 
FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(violation) >= 2;

UPDATE fine
SET sum_fine = sum_fine * 2
WHERE (date_payment IS NULL) AND (name IN (SELECT name FROM temp));

SELECT * FROM fine;


-- в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment; 
-- уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых 
-- занесена в таблицу payment) , если оплата произведена не позднее 20 дней со дня нарушения.
UPDATE fine, payment
SET fine.date_payment = payment.date_payment
WHERE fine.date_violation = payment.date_violation AND fine.name = payment.name;
UPDATE fine, payment 
SET fine.sum_fine = fine.sum_fine / 2
WHERE fine.date_violation = payment.date_violation AND fine.name = payment.name AND DATEDIFF(fine.date_payment, fine.date_violation)  <= 20;   
    
SELECT * FROM fine;


-- Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах 
-- (Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine.
CREATE TABLE back_payment AS
SELECT name, number_plate, violation, sum_fine, date_violation 
FROM fine
WHERE date_payment IS NULL;

SELECT * FROM back_payment;


-- Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года. 
DELETE FROM fine 
WHERE date_violation < '2020-02-01';

SELECT * FROM fine;