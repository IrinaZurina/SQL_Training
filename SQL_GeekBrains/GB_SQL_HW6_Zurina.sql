/* Написать функцию, которая удаляет всю информацию об указанном пользователе из БД vk. Пользователь задается по id. 
Удалить нужно все сообщения, лайки, медиа записи, профиль и запись из таблицы users. Функция должна возвращать номер пользователя.*/
USE vk;
DROP FUNCTION IF EXISTS delete_all_user_info;

DELIMITER // 
CREATE FUNCTION delete_all_user_info(user_to_delete BIGINT UNSIGNED)
RETURNS BIGINT UNSIGNED READS SQL DATA
BEGIN
	SET FOREIGN_KEY_CHECKS=0;
    
    DELETE FROM messages 
    WHERE (from_user_id = user_to_delete) OR (to_user_id = user_to_delete);
    
    DELETE FROM media
    WHERE user_id = user_to_delete;
    
    DELETE FROM likes
    WHERE user_id = user_to_delete;
          
    DELETE FROM profiles
    WHERE user_id = user_to_delete;
    
    DELETE FROM users
    WHERE id = user_to_delete;
    
    DELETE FROM friend_requests
    WHERE (initiator_user_id = user_to_delete) OR (target_user_id = user_to_delete);
    
    DELETE FROM users_communities
    WHERE user_id = user_to_delete;
    
    SET FOREIGN_KEY_CHECKS=1;
    
    RETURN user_to_delete;
END //
DELIMITER ;

SELECT delete_all_user_info(1);


-- Предыдущую задачу решить с помощью процедуры и обернуть используемые команды в транзакцию внутри процедуры.

DROP PROCEDURE IF EXISTS `sp_delete_user`;

DELIMITER $$

CREATE PROCEDURE `sp_delete_user`(user_to_delete BIGINT UNSIGNED, 
	OUT tran_result varchar(200))
BEGIN
    DECLARE `_rollback` BOOL DEFAULT 0;
   	DECLARE code varchar(100);
   	DECLARE error_string varchar(100);

   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
   begin
    	SET `_rollback` = 1;
	GET stacked DIAGNOSTICS CONDITION 1
          code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
    	set tran_result := concat('Error occured. Code: ', code, '. Text: ', error_string);
    end;
		        
    START TRANSACTION;
		SET FOREIGN_KEY_CHECKS=0;
    
		DELETE FROM messages 
		WHERE (from_user_id = user_to_delete) OR (to_user_id = user_to_delete);
    
		DELETE FROM media
		WHERE user_id = user_to_delete;
    
		DELETE FROM likes
		WHERE user_id = user_to_delete;
          
		DELETE FROM profiles
		WHERE user_id = user_to_delete;
    
		DELETE FROM users
		WHERE id = user_to_delete;
    
		DELETE FROM friend_requests
		WHERE (initiator_user_id = user_to_delete) OR (target_user_id = user_to_delete);
    
		DELETE FROM users_communities
		WHERE user_id = user_to_delete;
    
		SET FOREIGN_KEY_CHECKS=1;
	
	    IF `_rollback` THEN
	       ROLLBACK;
	    ELSE
		set tran_result := 'ok';
	       COMMIT;
	    END IF;
END$$

DELIMITER ;

call sp_delete_user(3, @tran_result);
select @tran_result;


/* * Написать триггер, который проверяет новое появляющееся сообщество. Длина названия сообщества (поле name) 
должна быть не менее 5 символов. Если требование не выполнено, то выбрасывать исключение с пояснением.*/

DROP TRIGGER IF EXISTS check_community_name_before_insert;

DELIMITER //

CREATE TRIGGER check_community_name_before_insert 
BEFORE INSERT ON communities
FOR EACH ROW
begin
    IF LENGTH(NEW.name) < 5 THEN
        SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Обновление отменено. Название сообщество должно содеражать минимум 5 символов.';
    END IF;
END//
