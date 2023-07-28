USE gb_sql_homework5;

/* 1. Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, с помощью которой можно переместить любого (одного) 
пользователя из таблицы users в таблицу users_old. (использование транзакции с выбором commit или rollback – обязательно).*/ 

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

DELIMITER //
DROP PROCEDURE IF EXISTS move_user_to_users_old//

CREATE PROCEDURE move_user_to_users_old(IN value INT, OUT tran_result VARCHAR(20))
BEGIN
    DECLARE `_rollback` BIT DEFAULT b'0';
	DECLARE code varchar(100);
	DECLARE error_string varchar(100); 

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
 		SET `_rollback` = b'1';
 		GET stacked DIAGNOSTICS CONDITION 1
		code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
	END;
    
    START TRANSACTION;
    INSERT INTO users_old (firstname, lastname, email)
    SELECT firstname, lastname, email
	FROM users WHERE id = value;
    DELETE FROM users WHERE id = value;
    
    IF `_rollback` THEN
		SET tran_result = CONCAT('УПС. Ошибка: ', code, ' Текст ошибки: ', error_string);
		ROLLBACK;
	ELSE
		SET tran_result = 'O K';
		COMMIT;
	END IF;
    
END //
DELIMITER ;

CALL move_user_to_users_old(3, @tran_result);
SELECT @tran_result;

SELECT * FROM users_old;
SELECT * FROM users;

/* 2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/


DELIMITER //
DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello (value TIME)
RETURNS VARCHAR(20) NOT DETERMINISTIC
BEGIN
	IF HOUR(value) >= 6 AND HOUR(value) < 12
		THEN RETURN "Доброе утро";
	ELSEIF HOUR(value) >= 12 AND HOUR(value) < 18
		THEN RETURN "Добрый день";
	ELSEIF HOUR(value) >= 18 AND HOUR(value) <= 23
		THEN RETURN "Добрый вечер";
	ELSE RETURN "Доброй ночи";
    END IF;
END //
DELIMITER ;

SELECT hello(CURTIME());
