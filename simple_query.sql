-- SIMPLE QUERIES --

SELECT title, author FROM exhibit WHERE style = 'Postimpressionism';
/* Shows titles and authors in Post-impressionism style */

SELECT title, salary FROM position WHERE salary > 5000 ORDER BY salary DESC;
/* Shows position and it's salary if salary is over 5000 sorted by salary */

SELECT * FROM exhibit WHERE type = ‘Sculpture’;
/* Shows info about all sculptures in the museum */
