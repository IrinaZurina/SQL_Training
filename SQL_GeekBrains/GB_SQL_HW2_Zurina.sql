-- 1. Создать БД vk, исполнив скрипт _vk_db_creation.sql-- 
DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамиль', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
) COMMENT 'юзеры';

INSERT INTO `users` (`firstname`, `lastname`, `email`, `password_hash`, `phone`) 
VALUES 
("Shany","Friesen","javonte62@example.net","464bd7412515a7c7c21a362bbec6d369a9bc1121","244830"),
("Jacynthe","McKenzie","wolff.esmeralda@example.net","77893126d51c117c47eeca174770f3411629a342","5176948760"),
("Lacy","Renner","kristin87@example.com","385203a82585772a961e2a6e029ba532689c7f89","1"),
("Danielle","Crist","sidney02@example.net","ab08701207a8f1034c52f058f0a5471f6bfc1e11","339285"),
("Barbara","Lehner","missouri86@example.net","a37351537496518c416605654b06146432b90772","901"),
("Craig","Anderson","mrice@example.org","ac93d99b8820a1063a2dbff7625312a44d5f15f5","497048"),
("Althea","Stamm","franz36@example.net","113e354c633f78a1b529e8266a7aec24bc6b3e5c","288910"),
("Curt","Crooks","christiana49@example.com","15b79a5bddd3e4b5d7201cc341b6b1ecbcb98763","755337"),
("Larissa","Hane","kschowalter@example.net","3d0ba88e440bcc660b61fc5188677d90544d4702","504"),
("Verdie","Goodwin","schroeder.oma@example.org","a69cd31bf8d0fc7e8cd4617ac078fc03b9d2a87f","579");


DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
	
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `created_at`, `hometown`) 
VALUES 
(1,"f","1981-07-19","1000","2004-08-25 17:45:10","Port Eladio"),
(2,"f","1996-03-24","819","2010-02-28 14:58:09","Grantfurt"),
(3,"f","1995-11-24","913","2011-03-10 13:38:17","Willyburgh"),
(4,"m","1996-03-12","623","2013-02-21 02:26:24","South Forrestmouth"),
(5,"f","2001-08-08","320","2021-02-15 09:54:45","Adriennefurt"),
(6,"m","2004-07-29","610","2021-10-12 05:24:14","Elyssaview"),
(7,"f","2017-06-26","42","2023-04-25 17:18:55","Floridatown"),
(8,"m","1988-01-16","539","2014-05-01 10:41:08","Nikolausland"),
(9,"f","1973-02-03","903","2013-11-18 00:59:50","North Ashlynnburgh"),
(10,"m","2003-05-29","352","2023-02-16 22:16:18","Kunzefurt");


ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE -- (значение по умолчанию)
    ON DELETE RESTRICT; -- (значение по умолчанию)

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);
INSERT INTO `messages` (`from_user_id`, `to_user_id`, `body`, `created_at`) 
VALUES 
("4","6","Queen, pointing to Alice as he spoke. A cat may look at me like that! By this time it all is! I'll try and repeat","2021-09-13 07:13:48"),
("9","5","And argued each case with MINE,' said the Cat. 'I don't know one,", "2024-09-13 07:13:48"),
("4","7","She had quite forgotten the little creature down, and nobody spoke for some time with great curiosity. Soles and eels, of course, he said in a low, hurried tone. He looked anxiously over his.","2020-05-23 06:50:03"),
("9","6","He looked anxiously round, to make ONE respectable person! Soon her eye fell on a branch of a well? The Dormouse had closed its eyes were getting extremely small for a dunce? Go on!","2023-09-15 01:17:00"),
("3","8","Alice was a little of her sister, who was beginning to write with one eye", "2016-10-28 05:51:12"),
("10","3","Hatter was the same as they all spoke at once, with a little hot tea upon its nose. The Dormouse again took a minute or two sobs choked his voice.","2019-05-15 02:30:49"),
("5","6","Duchess, as pigs have to turn round on its axis-- Talking of axes, the Hatter and the jury had a wink of sleep these three little sisters.","2011-10-22 09:46:30"),
("7","3","'Who's making personal remarks now?' likely to win, that it's hardly worth while finishing the game.They very soon had to stop and untwist it.","2012-08-30 16:50:25"),
("9","10","Duchess's voice died away, even in the back. At last the Mouse, who was sitting on the hearth and grinning from ear to ear.","2017-08-19 16:37:28"),
("4","7","Last came a little shriek, and went on: 'But why did they draw?' said Alice, quite forgetting her promise", "1975-08-09 13:24:47");


DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	-- id SERIAL, -- изменили на составной ключ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'), # DEFAULT 'requested',
    -- `status` TINYINT(1) UNSIGNED, -- в этом случае в коде хранили бы цифирный enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, -- можно будет даже не упоминать это поле при обновлении
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)-- ,
    -- CHECK (initiator_user_id <> target_user_id)
);
-- чтобы пользователь сам себе не отправил запрос в друзья
-- ALTER TABLE friend_requests 
-- ADD CHECK(initiator_user_id <> target_user_id);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name), -- индексу можно давать свое имя (communities_name_idx)
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), -- записей мало, поэтому в индексе нет необходимости
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    -- file BLOB,    	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()

    -- PRIMARY KEY (user_id, media_id) – можно было и так вместо id в качестве PK
  	-- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)  

/* намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме
    , FOREIGN KEY (user_id) REFERENCES users(id)
    , FOREIGN KEY (media_id) REFERENCES media(id)
*/
);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);


-- 2. Написать скрипт, добавляющий в созданную БД vk 2-3 новые таблицы
DROP TABLE IF EXISTS audio;
CREATE TABLE audio (
    id SERIAL, 
    user_id BIGINT UNSIGNED NOT NULL,
    artist VARCHAR(50),
    title VARCHAR(50),        
    duration INT, -- в секундах
    created_at DATETIME DEFAULT NOW(),

    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS voice_mail;
CREATE TABLE voice_mail (
    id SERIAL, 
    owner_id BIGINT UNSIGNED NOT NULL,
    duration INT, -- в секундах
    link_mp3 VARCHAR(100),

    FOREIGN KEY (owner_id) REFERENCES users(id)
);



-- 3. Заполнить 2 таблицы БД vk данными (по 10 записей в каждой таблице) --
INSERT INTO `audio` (`user_id`, `artist`, `title`, `duration`, `created_at`) 
VALUES 
("6","non","Aut natus inventore quasi amet inventore.","143","1998-11-24 08:29:44"),
("2","quia","Tempora laborum veritatis dolores architecto atque","145","1991-04-07 01:11:31"),
("9","suscipit","Sunt et sapiente adipisci dolor ut optio.","434","2011-08-20 03:45:02"),
("7","ad","Explicabo voluptas odit laborum qui soluta.","223","2015-06-23 03:58:45"),
("6","at","Doloremque nulla nesciunt sequi eum qui.","142","1987-07-26 03:42:55"),
("3","blanditiis","Quam modi consectetur accusantium maxime rerum qua","380","2010-06-27 08:05:16"),
("9","deserunt","Aspernatur architecto facere aut impedit nesciunt.","325","1978-11-30 08:22:55"),
("5","soluta","Nam et delectus temporibus ut neque.","351","2011-04-02 12:40:42"),
("2","quidem","Cum enim sed suscipit aliquam commodi fugiat.","212","1996-09-26 09:52:05"),
("6","magni","Atque nisi sed autem.","424","2020-12-18 21:18:18");

INSERT INTO `voice_mail` (`owner_id`, `duration`, `link_mp3`) 
VALUES 
("2","537","http://gusikowski.com/"),
("1","425","http://gerlachmoen.net/"),
("6","494","http://johnson.com/"),
("4","195","http://www.torp.net/"),
("2","418","http://www.koss.com/"),
("2","416","http://leffler.com/"),
("9","179","http://www.cartwright.info/"),
("5","98","http://www.schinner.com/"),
("4","143","http://mertz.com/"),
("8","395","http://davisdicki.com/");

/* 4. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = true). 
При необходимости предварительно добавить такое поле в таблицу profiles со значением по умолчанию = false (или 0)*/
ALTER TABLE profiles 
ADD COLUMN is_active BIT;

UPDATE profiles
SET is_active = 1 
WHERE DATEDIFF(CURDATE(), birthday) / 365 >= 18;

UPDATE profiles
SET is_active = 0 
WHERE DATEDIFF(CURDATE(), birthday) / 365 < 18;

--  Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней) --
DELETE FROM messages
WHERE created_at > NOW();

