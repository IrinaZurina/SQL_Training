USE vk;

-- Подсчитать количество групп (сообществ), в которые вступил каждый пользователь.
SELECT user_id, COUNT(community_id) as number_of_communities
FROM users_communities
GROUP  BY user_id;

-- Подсчитать количество пользователей в каждом сообществе.
SELECT name, COUNT(user_id) as number_of_users
FROM communities c JOIN users_communities uc
ON c.id = uc.community_id
GROUP BY name;

-- Пусть задан некоторый пользователь. Из всех пользователей соц. сети найдите человека, который больше всех общался с выбранным пользователем (написал ему сообщений).
-- Для выполнения задания выбран пользователь с id = 1
CREATE VIEW friends_list as
(SELECT initiator_user_id as user_id, target_user_id as friend_id
FROM friend_requests 
WHERE `status` = 'approved' AND initiator_user_id = 1)
UNION
(SELECT  target_user_id as user_id,   initiator_user_id as friend_id
FROM friend_requests 
WHERE `status` = 'approved' AND target_user_id = 1);

SELECT f.friend_id, COUNT(body) as number_of_messages
FROM friends_list f LEFT JOIN messages m
ON f.user_id = m.to_user_id AND f.friend_id = m.from_user_id
GROUP BY f.friend_id
ORDER BY number_of_messages DESC
LIMIT 1;

-- * Подсчитать общее количество лайков, которые получили пользователи младше 18 лет..
SELECT COUNT(media_id)
FROM (SELECT p.user_id, m.id, l.media_id FROM profiles p
	  LEFT JOIN media m USING(user_id)
      LEFT JOIN likes l ON m.id = l.media_id
      WHERE (DATEDIFF(CURDATE(), birthday) / 365) < 18) as tmp;

-- * Определить кто больше поставил лайков (всего): мужчины или женщины.
SELECT IF((SELECT COUNT(user_id) FROM (SELECT l.user_id, gender
									   FROM likes l LEFT JOIN profiles p USING(user_id)) as tmp
                                       WHERE gender = 'f') > 
		  (SELECT COUNT(user_id) FROM (SELECT l.user_id, gender
                                       FROM likes l LEFT JOIN profiles p USING(user_id)) as tmp
                                       WHERE gender = 'm'), 'female', 'male') as result;