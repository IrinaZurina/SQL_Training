-- Вывести название, жанр и цену тех книг, количество которых больше 8, в отсортированном по убыванию цены виде.
SELECT title, name_genre, price
FROM
    genre INNER JOIN book
    ON genre.genre_id = book.genre_id
WHERE book.amount > 8
ORDER BY book.price DESC;


-- Вывести все жанры, которые не представлены в книгах на складе.
SELECT name_genre
FROM genre
WHERE name_genre IN (SELECT name_genre
FROM book RIGHT JOIN genre
    ON book.genre_id = genre.genre_id
WHERE book.title IS NULL);


-- Есть список городов, хранящийся в таблице city
-- Необходимо в каждом городе провести выставку книг каждого автора в течение 2020 года. Дату проведения выставки выбрать случайным образом. 
-- Создать запрос, который выведет город, автора и дату проведения выставки. Последний столбец назвать Дата. Информацию вывести, 
-- отсортировав сначала в алфавитном порядке по названиям городов, а потом по убыванию дат проведения выставок.
SELECT
    name_city,
    name_author,
    DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND()*365) DAY) AS Дата
FROM city,author
ORDER BY
    name_city,
    Дата DESC;


--  Вывести информацию о книгах (жанр, книга, автор), относящихся к жанру, включающему слово «роман» в отсортированном по названиям книг виде.
SELECT name_genre, title, name_author
FROM
    genre 
    INNER JOIN  book ON book.genre_id = genre.genre_id
    INNER JOIN author ON author.author_id = book.author_id
WHERE name_genre LIKE 'роман'
ORDER BY title;


-- Посчитать количество экземпляров  книг каждого автора из таблицы author.  Вывести тех авторов,  количество книг которых меньше 10, 
-- в отсортированном по возрастанию количества виде. Последний столбец назвать Количество.
SELECT name_author, sum(amount) AS Количество
FROM 
    author LEFT JOIN book
    on author.author_id = book.author_id
GROUP BY name_author
HAVING Количество < 10 OR Количество IS NULL
ORDER BY Количество; 


-- Вывести в алфавитном порядке всех авторов, которые пишут только в одном жанре. Поскольку у нас в таблицах так занесены данные, 
-- что у каждого автора книги только в одном жанре,  для этого запроса внесем изменения в таблицу book. Пусть у нас  книга Есенина 
-- «Черный человек» относится к жанру «Роман», а книга Булгакова «Белая гвардия» к «Приключениям» (эти изменения в таблицы уже внесены).
SELECT DISTINCT name_author
FROM author INNER JOIN book
ON author.author_id = book.author_id
WHERE book.author_id IN (
    SELECT author_id
    FROM (
        SELECT author_id, COUNT(DISTINCT genre_id) AS count_genre
        FROM book GROUP BY author_id HAVING count_genre = 1)
    AS query_in) ;


-- Вывести информацию о книгах (название книги, фамилию и инициалы автора, название жанра, цену и количество экземпляров книги), 
-- написанных в самых популярных жанрах, в отсортированном в алфавитном порядке по названию книг виде. Самым популярным считать жанр, 
-- общее количество экземпляров книг которого на складе максимально.
SELECT  title, name_author, name_genre, price, amount
FROM 
    author 
    INNER JOIN book ON author.author_id = book.author_id
    INNER JOIN genre ON  book.genre_id = genre.genre_id
WHERE genre.genre_id IN
         (/* выбираем автора, если он пишет книги в самых популярных жанрах*/
          SELECT query_in_1.genre_id
          FROM 
              ( /* выбираем код жанра и количество произведений, относящихся к нему */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
               )query_in_1
          INNER JOIN 
              ( /* выбираем запись, в которой указан код жанр с максимальным количеством книг */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
                ORDER BY sum_amount DESC
                LIMIT 1
               ) query_in_2
          ON query_in_1.sum_amount= query_in_2.sum_amount
         )
ORDER BY title;   


-- Если в таблицах supply  и book есть одинаковые книги, которые имеют равную цену,  вывести их название и автора, 
-- а также посчитать общее количество экземпляров книг в таблицах supply и book,  столбцы назвать Название, Автор  и Количество.
SELECT book.title AS Название, name_author AS Автор, (book.amount + supply.amount) AS Количество
FROM
    author
    INNER JOIN book USING (author_id)
    INNER JOIN supply ON book.title = supply.title
                         and author.name_author = supply.author
WHERE book.price = supply.price ;