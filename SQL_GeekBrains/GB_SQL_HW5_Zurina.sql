USE vk;

-- Создайте представление с произвольным SELECT-запросом из прошлых уроков [CREATE VIEW]

CREATE VIEW users_in_communities AS
(SELECT name, COUNT(user_id) as number_of_users
FROM communities c JOIN users_communities uc
ON c.id = uc.community_id
GROUP BY name);

-- Выведите данные, используя написанное представление [SELECT]
SELECT name, number_of_users
FROM users_in_communities;

-- Удалите представление [DROP VIEW]
DROP VIEW users_in_communities;

/* * Сколько новостей (записей в таблице media) у каждого пользователя? Вывести поля: news_count (количество новостей), 
user_id (номер пользователя), user_email (email пользователя). Попробовать решить с помощью CTE или с помощью обычного JOIN.*/

WITH number_of_news (user_id, user_email, news_id)AS 
(SELECT m.user_id, u.email, m.id
FROM media m LEFT JOIN users u
ON m.user_id = u.id)
SELECT user_id, user_email, COUNT(news_id) AS news_count
FROM number_of_news
GROUP BY user_id;
