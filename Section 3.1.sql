-- Вывести студентов, которые сдавали дисциплину «Основы баз данных», указать дату попытки и результат. 
-- Информацию вывести по убыванию результатов тестирования.
SELECT name_student, date_attempt, result
FROM subject
     INNER JOIN attempt USING (subject_id)
     INNER JOIN student USING (student_id)
WHERE name_subject = 'Основы баз данных'
ORDER BY result DESC;


-- Вывести, сколько попыток сделали студенты по каждой дисциплине, а также средний результат попыток, 
-- который округлить до 2 знаков после запятой. Под результатом попытки понимается процент правильных 
-- ответов на вопросы теста, который занесен в столбец result.  В результат включить название дисциплины, 
-- а также вычисляемые столбцы Количество и Среднее. Информацию вывести по убыванию средних результатов.
SELECT name_subject, COUNT(attempt_id) as Количество, ROUND(AVG(result), 2) AS Среднее
FROM subject LEFT JOIN attempt USING (subject_id)
GROUP by name_subject
ORDER BY Среднее DESC;


-- Вывести студентов (различных студентов), имеющих максимальные результаты попыток. 
-- Информацию отсортировать в алфавитном порядке по фамилии студента.
SELECT name_student, result
FROM student INNER JOIN attempt USING (student_id)
WHERE result = (SELECT MAX(result) FROM attempt)
ORDER BY name_student;


-- Если студент совершал несколько попыток по одной и той же дисциплине, то вывести разницу в днях 
-- между первой и последней попыткой. В результат включить фамилию и имя студента, название дисциплины 
-- и вычисляемый столбец Интервал. Информацию вывести по возрастанию разницы. 
-- Студентов, сделавших одну попытку по дисциплине, не учитывать. 
SELECT name_student, name_subject, DATEDIFF(MAX(date_attempt), MIN(date_attempt)) AS Интервал
FROM subject INNER JOIN attempt USING (subject_id)
             INNER JOIN student USING (student_id)
GROUP BY student_id, subject_id
HAVING Count(attempt_id) > 1
ORDER BY Интервал;     


-- Студенты могут тестироваться по одной или нескольким дисциплинам (не обязательно по всем). 
-- Вывести дисциплину и количество уникальных студентов (столбец назвать Количество), которые по ней 
-- проходили тестирование . Информацию отсортировать сначала по убыванию количества, а потом по 
-- названию дисциплины. В результат включить и дисциплины, тестирование по которым студенты еще 
-- не проходили, в этом случае указать количество студентов 0.
SELECT name_subject, COUNT(DISTINCT(student_id)) AS Количество
FROM subject LEFT JOIN attempt USING(subject_id)
GROUP BY name_subject
ORDER BY Количество DESC, name_subject;


-- Случайным образом отберите 3 вопроса по дисциплине «Основы баз данных». 
-- В результат включите столбцы question_id и name_question.
SELECT question_id, name_question
FROM question INNER JOIN subject USING (subject_id)
WHERE name_subject = 'Основы баз данных'
ORDER BY RAND()
LIMIT 3;


-- Вывести вопросы, которые были включены в тест для Семенова Ивана по дисциплине «Основы SQL» 
-- 2020-05-17  (значение attempt_id для этой попытки равно 7). Указать, какой ответ дал студент 
-- и правильный он или нет (вывести Верно или Неверно). В результат включить вопрос, ответ и вычисляемый столбец  Результат.
SELECT name_question, name_answer, IF(is_correct = 1, 'Верно', 'Неверно') AS Результат
FROM question INNER JOIN testing USING (question_id)
              INNER JOIN answer USING (answer_id)
WHERE attempt_id = 7;    


-- Посчитать результаты тестирования. Результат попытки вычислить как количество правильных ответов, 
-- деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100. Результат округлить до 
-- двух знаков после запятой. Вывести фамилию студента, название предмета, дату и результат. 
-- Последний столбец назвать Результат. Информацию отсортировать сначала по фамилии студента, потом по убыванию даты попытки.
SELECT name_student, name_subject, date_attempt, ROUND((SUM(is_correct) * 100 / 3), 2) AS Результат
FROM answer
        JOIN testing USING(answer_id)
        JOIN attempt USING(attempt_id)
        JOIN subject USING(subject_id)     
        JOIN student USING(student_id)
GROUP BY name_student, name_subject, date_attempt
ORDER BY name_student, date_attempt DESC;


-- Для каждого вопроса вывести процент успешных решений, то есть отношение количества верных 
-- ответов к общему количеству ответов, значение округлить до 2-х знаков после запятой. 
-- Также вывести название предмета, к которому относится вопрос, и общее количество ответов 
-- на этот вопрос. В результат включить название дисциплины, вопросы по ней (столбец назвать 
-- Вопрос), а также два вычисляемых столбца Всего_ответов и Успешность. Информацию отсортировать
-- сначала по названию дисциплины, потом по убыванию успешности, а потом по тексту вопроса в алфавитном порядке.
-- Поскольку тексты вопросов могут быть длинными, обрезать их 30 символов и добавить многоточие "...".
SELECT name_subject, CONCAT(SUBSTRING(name_question, 1, 30), '...') AS Вопрос, COUNT(testing.answer_id) AS Всего_ответов, ROUND((SUM(is_correct)/COUNT(testing.answer_id)) * 100, 2) AS Успешность
 FROM subject
       JOIN question USING(subject_id)
       JOIN testing USING(question_id)
       LEFT JOIN answer USING(answer_id)
GROUP BY name_subject, name_question
ORDER BY name_subject, Успешность DESC, name_question;