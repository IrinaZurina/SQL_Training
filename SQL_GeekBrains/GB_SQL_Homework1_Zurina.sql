USE gb_sql_homework1;

SELECT * FROM mobile_phones;

-- Напишите SELECT-запрос, который выводит название товара, производителя и цену для товаров, количество которых превышает 2
SELECT product_name, manufacturer, price
FROM mobile_phones
WHERE product_count > 2;

-- Выведите SELECT-запросом весь ассортимент товаров марки “Samsung”
SELECT id, product_name, manufacturer, price, product_count
FROM mobile_phones
WHERE manufacturer = 'Samsung';

-- Товары, в которых есть упоминание "Iphone"
SELECT id, product_name, manufacturer, price, product_count
FROM mobile_phones
WHERE product_name LIKE '%iPhone%';

-- Товары, в которых есть упоминание "Samsung"
SELECT id, product_name, manufacturer, price, product_count
FROM mobile_phones
WHERE manufacturer LIKE '%Samsung%';

-- Товары, в названии которых есть ЦИФРЫ
SELECT id, product_name, manufacturer, price, product_count
FROM mobile_phones
WHERE REGEXP_LIKE(product_name, '[0-9]');

-- Товары, в названии которых есть ЦИФРА "8"
SELECT id, product_name, manufacturer, price, product_count
FROM mobile_phones
WHERE product_name LIKE '%8%';
