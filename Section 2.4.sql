-- Вывести все заказы Баранова Павла (id заказа, какие книги, по какой цене и в каком количестве он заказал)
-- в отсортированном по номеру заказа и названиям книг виде.
SELECT buy.buy_id, book.title, book.price, buy_book.amount
FROM book
     INNER JOIN buy_book ON book.book_id = buy_book.book_id
     INNER JOIN buy ON buy_book.buy_id = buy.buy_id
     INNER JOIN client ON buy.client_id = client.client_id
WHERE client.name_client = 'Баранов Павел'
ORDER BY buy.buy_id, book.title;


-- Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора 
-- (нужно посчитать, в каком количестве заказов фигурирует каждая книга).  
-- Вывести фамилию и инициалы автора, название книги, последний столбец назвать Количество. 
-- Результат отсортировать сначала  по фамилиям авторов, а потом по названиям книг.
SELECT author.name_author, book.title, COUNT(buy_book.amount) AS Количество
FROM author
     INNER JOIN book on author.author_id = book.author_id
     LEFT JOIN buy_book ON book.book_id = buy_book.book_id
GROUP BY book.book_id
ORDER BY author.name_author, book.title;


-- Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. 
-- Указать количество заказов в каждый город, этот столбец назвать Количество.
-- Информацию вывести по убыванию количества заказов, а затем в алфавитном порядке по названию городов.
SELECT city.name_city, COUNT(buy.buy_id) AS Количество
FROM city
     INNER JOIN client ON city.city_id = client.city_id
     INNER JOIN buy ON client.client_id = buy.client_id
GROUP BY city.city_id
ORDER BY Количество DESC, city.name_city;


-- Вывести номера всех оплаченных заказов и даты, когда они были оплачены.
SELECT buy_id, date_step_end
FROM step 
     INNER JOIN buy_step ON step.step_id = buy_step.step_id
WHERE step.step_id = 1 AND date_step_end IS NOT NULL;


-- Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость 
-- (сумма произведений количества заказанных книг и их цены), в отсортированном по номеру заказа виде. Последний столбец назвать Стоимость.
SELECT buy.buy_id, client.name_client, SUM(book.price*buy_book.amount) AS Стоимость
FROM client
     INNER JOIN buy ON client.client_id = buy.client_id
     INNER JOIN buy_book ON buy.buy_id = buy_book.buy_id
     INNER JOIN book ON buy_book.book_id = book.book_id
GROUP BY buy.buy_id
ORDER BY buy.buy_id;


--Вывести номера заказов (buy_id) и названия этапов,  на которых они в данный момент находятся. 
-- Если заказ доставлен –  информацию о нем не выводить. Информацию отсортировать по возрастанию buy_id.
SELECT buy_id, name_step
FROM step INNER JOIN buy_step on step.step_id = buy_step.step_id
WHERE date_step_beg IS NOT NULL AND date_step_end IS NULL
ORDER BY buy_id;


-- В таблице city для каждого города указано количество дней, за которые заказ может быть доставлен в этот город 
-- (рассматривается только этап Транспортировка). Для тех заказов, которые прошли этап транспортировки, вывести 
-- количество дней за которое заказ реально доставлен в город. А также, если заказ доставлен с опозданием, указать 
-- количество дней задержки, в противном случае вывести 0. В результат включить номер заказа (buy_id), 
-- а также вычисляемые столбцы Количество_дней и Опоздание. Информацию вывести в отсортированном по номеру заказа виде.
SELECT buy_step.buy_id,
    DATEDIFF(date_step_end, date_step_beg) AS Количество_дней,         
    IF (DATEDIFF(date_step_end, date_step_beg)-days_delivery>0, DATEDIFF(date_step_end, date_step_beg)-days_delivery, 0) AS Опоздание
FROM city INNER JOIN client on city.city_id = client.city_id
     INNER JOIN buy ON client.client_id = buy.client_id
     INNER JOIN buy_step ON buy.buy_id = buy_step.buy_id
     INNER JOIN step ON buy_step.step_id = step.step_id
WHERE step.name_step = 'Транспортировка' AND buy_step.date_step_end IS NOT NULL
ORDER BY buy.buy_id;


-- Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в отсортированном по алфавиту виде. 
-- В решении используйте фамилию автора, а не его id.
SELECT DISTINCT name_client
FROM author INNER JOIN book ON author.author_id = book.author_id
     INNER JOIN buy_book ON book.book_id = buy_book.book_id
     INNER JOIN buy ON buy_book.buy_id = buy.buy_id
     INNER JOIN client ON buy.client_id = client.client_id
WHERE name_author LIKE 'Достоевский%'
ORDER BY name_client;


-- Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг, 
-- указать это количество. Последний столбец назвать Количество.
SELECT name_genre, SUM(buy_book.amount) AS Количество
     FROM buy_book INNER JOIN book USING (book_id)
     INNER JOIN genre USING (genre_id)
     GROUP BY name_genre
HAVING Количество = (
SELECT MAX(sum_amount) 
FROM (
    SELECT SUM(buy_book.amount) AS sum_amount 
      FROM buy_book INNER JOIN book USING (book_id) 
      GROUP BY genre_id) AS T); 
