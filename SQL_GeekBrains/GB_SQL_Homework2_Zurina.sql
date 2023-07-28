DROP DATABASE IF EXISTS gb_sql_homework2;
CREATE DATABASE gb_sql_homework2;
USE gb_sql_homework2;

-- 1. Используя операторы языка SQL, создайте табличку “sales”. Заполните ее данными.--
DROP TABLE IF EXISTS sales;
CREATE TABLE sales(
	id SERIAL PRIMARY KEY,
	order_date DATE,
	count_product INT
);

INSERT INTO sales(order_date, count_product)
VALUES ("2022-01-01", 156),
	   ("2022-01-02", 180),
	   ("2022-01-03", 21),
       ("2022-01-04", 124),
       ("2022-01-05", 341);

/* 2. Для данных таблицы “sales” укажите тип заказа в зависимости от кол-ва :
меньше 100 - Маленький заказ; от 100 до 300 - Средний заказ; больше 300 - Большой заказ.*/

SELECT id, order_date, count_product,
	   IF (count_product < 100, "Маленький заказ", 
       IF (count_product > 300, "Большой заказ", "Средний заказ")) AS Тип_заказа
FROM sales;

/* 3. Создайте таблицу “orders”, заполните ее значениями.
Выберите все заказы. В зависимости от поля order_status выведите столбец full_order_status:
OPEN – «Order is in open state» ; CLOSED - «Order is closed»; CANCELLED - «Order is cancelled» */

DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
	id SERIAL PRIMARY KEY,
	employee_id VARCHAR(15),
	amount FLOAT,
    order_status VARCHAR(10)
);

INSERT INTO orders(employee_id, amount, order_status)
VALUES ("e03", 15.00, "OPEN"),
	   ("e01", 25.50, "OPEN"),
       ("e05", 100.70, "CLOSED"),
       ("e02", 22.18, "OPEN"),
       ("e04", 9.50, "CANCELLED");
       
SELECT id, employee_id, amount, order_status,
	   CASE order_status
			WHEN "OPEN" THEN "Order is in open state"
            WHEN "CLOSED" THEN "Order is closed"
            WHEN "CANCELLED" THEN "Order is cancelled"
		END AS full_order_status
FROM orders;   

/* 4. Чем 0 отличается от NULL?
NULL - поле, не содержащее никакого значения, пустое поле;
0 - это значение поля*/
