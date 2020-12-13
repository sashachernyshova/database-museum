-- MEDIUM QUERIES --


SELECT first_name, last_name, title, salary FROM worker JOIN position ON worker.position_id = position.id
WHERE position.salary > 20000;
/*  Shows workers' full name and their salaries where salaries are over 20000 */


SELECT title,first_name, last_name,time_start,time_end
FROM worker JOIN caretaker_shift ON worker.id = caretaker_shift.worker_id JOIN hall ON hall.id = caretaker_shift.hall_id
WHERE time_start>'13:00' AND caretaker_shift.week_day ='Monday';
/* Shows halls, caretakers and their shifts on Monday after 13:00 */


SELECT author, exhibit.title
FROM exhibit JOIN hall  ON exhibit.hall_id = hall.id WHERE hall.title ='The Rubens Room';
/* Shows titles of exhibits and their authors that are located in the Rubens Room */
