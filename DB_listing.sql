CREATE FUNCTION time_subtype_diff(x time, y time) RETURNS float8 AS
'SELECT EXTRACT(EPOCH FROM (x - y))' LANGUAGE sql STRICT IMMUTABLE;


CREATE TYPE timerange AS RANGE (
    subtype = time,
    subtype_diff = time_subtype_diff
);


CREATE TYPE hall_title AS ENUM ('The Rossi Hall','The Malachite Room','The Concert Hall',
    'The War Gallery of 1812','The St. George Hall','The Alexander Hall',
    'Room of British Art','Pavilion Hall','The Gallery of the History of Ancient Painting',
    'The Rubens Room','The Athena Room');


CREATE TYPE position_title AS ENUM('Caretaker','Guide','Accountant','Restorer','Сleaner',
    'Procurement specialist','Intern','CEO','IT-specialist');


CREATE TYPE weekday AS ENUM ('Monday' ,'Tuesday' ,'Wednesday', 'Thursday', 'Friday',
    'Saturday', 'Sunday');



CREATE TABLE "exhibit" (
	"id" serial PRIMARY KEY,
	"title" varchar(255) NOT NULL ,
	"author" varchar(100) NULL,
	"typology" varchar(45) NOT NULL,
	"style" varchar(45) NOT NULL,
	"hall_id" int NOT NULL,
	UNIQUE (title,author)
);



CREATE TABLE "hall" (
	"id" serial PRIMARY KEY ,
	"title" hall_title NOT NULL,
	"number_of_stands" int NOT NULL,
	CONSTRAINT number_of_stands_check CHECK ( number_of_stands > 0 )
);



CREATE TABLE "worker" (
	"id" serial PRIMARY KEY,
	"first_name" varchar(45) NOT NULL,
	"last_name" varchar(45) NOT NULL,
	"position_id" int NOT NULL
);



CREATE TABLE "position" (
	"id" serial PRIMARY KEY ,
	"title" position_title NOT NULL,
	"salary" DECIMAL NOT NULL
);



CREATE EXTENSION btree_gist;
CREATE TABLE "caretaker_shift" (
	"id" serial PRIMARY KEY ,
	"hall_id" int NOT NULL,
	"worker_id" int NOT NULL,
	"time_start" TIME NOT NULL,
	"time_end" TIME NOT NULL,
	"week_day" weekday NOT NULL,
	EXCLUDE USING gist (hall_id WITH =, week_day WITH =, timerange(time_start, time_end) WITH &&),
	EXCLUDE USING gist(worker_id WITH =, week_day WITH =, timerange(time_start, time_end) WITH &&)
);



CREATE TABLE "excursion_type" (
	"id" serial PRIMARY KEY ,
	"title" varchar(45) NOT NULL UNIQUE,
	"cost" int NOT NULL,
	CONSTRAINT cost_check CHECK (cost > 0)
);



CREATE TABLE "excursion" (
	"id" serial PRIMARY KEY,
	"excursion_type_id" int NOT NULL,
	"datetime_start" TIMESTAMP NOT NULL,
	"datetime_end" TIMESTAMP NOT NULL,
	"worker_id" int NOT NULL,
	"visitors_amount" int NOT NULL,
	CONSTRAINT visitors_amount_check CHECK (visitors_amount > 0),
	EXCLUDE USING gist (worker_id WITH =, tsrange(datetime_start,datetime_end) WITH &&),
    EXCLUDE USING gist (excursion_type_id WITH =, tsrange(datetime_start,datetime_end) WITH &&)
);



CREATE TABLE "excursion_hall" (
	"id" serial PRIMARY KEY,
	"excursion_type_id" int NOT NULL,
	"hall_id" int NOT NULL,
	"order_number" int NOT NULL,
	UNIQUE (excursion_type_id, hall_id),
	UNIQUE  (excursion_type_id, order_number)
);





 INSERT INTO worker (first_name, last_name, position_id) VALUES
    ('Alexandra', 'Chernyshova','8'),
    ('Barden','Balthazarov','1'),
    ('Cleopatra','Luminova','2'),
    ('Ophelia', 'Floodova','3'),
    ('Angela','Runnin','4'),
    ('Gloria','Shiner','5'),
    ('Jack','Burton','6'),
    ('Helena','Carter','1'),
    ('Hey','Ho','6'),
    ('Zemfira','Piterskaya','9'),
    ('Lana','Banana','7'),
    ('Diana','Rey','1'),
    ('Loic','Annen','1'),
    ('Sebastian','May','2'),
    ('William','Kantereit','2'),
    ('Frank','Sinatra','1'),
    ('Mark','Talevski','1'),
    ('James','Blunt','1'),
    ('Sasha','Sloan','1'),
    ('Eric','Satie','1'),
    ('Jon','Snow','1'),
    ('Arya','Stark','1');



INSERT INTO position (title, salary) VALUES
    ('Caretaker','5000'),
    ('Guide','15000'),
    ('Accountant','20000'),
    ('Restorer','30000'),
    ('Сleaner','5000'),
    ('Procurement specialist','25000'),
    ('Intern','1000'),
    ('CEO','60000'),
    ('IT-specialist','30000');



INSERT INTO hall (title, number_of_stands) VALUES
    ('The Rossi Hall','38'),
    ('The Malachite Room','26'),
    ('The Concert Hall','20'),
    ('The War Gallery of 1812','246'),
    ('The St. George Hall','25'),
    ('The Alexander Hall','49'),
    ('Room of British Art','43'),
    ('Pavilion Hall','52'),
    ('The Gallery of the History of Ancient Painting','123'),
    ('The Rubens Room','24'),
    ('The Athena Room','42');



INSERT INTO excursion_type (title, cost) VALUES
    ('All-in-excursion','6000'),
    ('Greek art','1500'),
    ('Music of stone','1000'),
    ('British Empire art','1200'),
    ('Classicism','3000'),
    ('Baroque','2500'),
    ('Battlefield','4000'),
    ('Ancient art','4500'),
    ('Breath of art','500');



INSERT INTO exhibit (title, author, typology, style, hall_id) VALUES
('Madonna Benoit','Leonardo da Vinci','Painting','Renaissance','10'),
('Madonna Litta','Leonardo da Vinci','Painting','Renaissance','10'),
('Breakfast','Diego Velazquez','Painting','Baroque','10'),
('Apostles Peter and Paul','El Greco','Painting','Mannerism','3'),
('Union of Earth and Water','Peter Paul Rubens','Painting','Baroque','10'),
('Portrait of a lady in blue','Thomas Gainsborough','Painting','Romanticism','8'),
('Huts','Vincent van Gogh','Painting','Postimpressionism','2'),
('Head of Hermes','Unknown','Sculpture','Antiquity','11'),
('Tombstone relief of Themistocles','Unknown','Sculpture','Antiquity','11'),
('Aphrodite (Venus Tauride)','Unknown','Sculpture','Hellenism','11'),
('Statue of Athena','Unknown','Sculpture','Antiquity','11'),
('Female portrait','Michael Dahl','Painting','Baroque','7'),
('Cupid unties the belt of Venus','Joshua Reynolds','Painting','Rococo','7'),
('Portrait of Queen Henrietta Mary','Anthony Van Dyck','Painting','Baroque','7'),
('Portrait of the staff captain of the Life Guards hussar regiment Pavel Semenovich Masyukov','Vladimir Lukich Borovikovsky','Painting','Neoclassicism','4'),
('Battle of Klyastitsy 19 (31) July 1812','Peter von Hess','Painting','Battle genre','4'),
('Portrait of Count N. D. Guryev','Jean Auguste Dominique Ingres','Painting','Official portrait','4'),
('Boy with falcon','Unknown','Painting','Persian Parsuna','9'),
('Boy with rose','Unknown','Painting','Persian Parsuna','9'),
('Slave sale','Jean-Leon Gerome','Painting','Romanticism','9'),
('Month of Mary (Te avae no Maria)','Paul Gauguin','Painting','Cloisonism','9'),
('Portrait of Philip IV, King of Spain','Peter Paul Rubens','Painting','Baroque','10'),
('Bacchus','Peter Paul Rubens','Painting','Baroque','10'),
('Landscape with a rainbow','Peter Paul Rubens','Painting','Baroque','10'),
('Types of rooms in the Winter Palace. Hall of the Council of Emperor Alexander I','Edward Petrovich Gau','Watercolor drawing','Interior sketches','6'),
('Types of rooms in the Small Hermitage. Pavilion hall','Alexander Khristoforovich Kolb','Watercolor drawing','Interior sketches','6'),
('Portrait of Field Marshal Prince Ivan Fyodorovich Paskevich','Egor Ivanovich Botman','Painting','Official portrait','5'),
('Portrait of Emperor Nicholas I','Egor Ivanovich Botman','Painting','Official portrait','5'),
('Sacrifice of Abraham','Giuseppe Rossi','Engraving','Western European engraving','1');



INSERT INTO excursion_hall (excursion_type_id, hall_id, order_number) VALUES
('1','1','1'),
('1','2','2'),
('1','3','3'),
('1','4','4'),
('1','5','5'),
('1','6','6'),
('1','7','7'),
('1','8','8'),
('1','9','9'),
('1','10','10'),
('1','11','11'),
('2','2','1'),
('2','9','2'),
('2','11','3'),
('3','2','1'),
('3','3','2'),
('3','8','3'),
('4','3','1'),
('4','5','2'),
('4','7','3'),
('5','1','1'),
('5','3','2'),
('5','5','3'),
('5','6','4'),
('5','8','5'),
('6','2','1'),
('6','3','2'),
('6','8','3'),
('6','10','4'),
('7','3','1'),
('7','4','2'),
('7','5','3'),
('7','6','4'),
('7','8','5'),
('8','1','1'),
('8','2','2'),
('8','6','3'),
('8','9','4'),
('8','11','5'),
('9','1','1'),
('9','8','2'),
('9','9','3'),
('9','10','4');



INSERT INTO excursion (excursion_type_id, datetime_start, datetime_end, worker_id, visitors_amount) VALUES
('1','2020-10-23 9:45:00','2020-10-23 11:36:00','2','12'),
('1','2020-10-24 14:30:00','2020-10-24 16:45:00','2','5'),
('4','2020-10-19 10:10:00','2020-10-19 11:41:00','2','6'),
('5','2020-10-23 12:45:00','2020-10-23 13:52:00','14','7'),
('2','2020-10-17 12:45:00','2020-10-17 13:54:00','15','8'),
('6','2020-10-17 14:45:00','2020-10-17 15:57:00','15','4'),
('7','2020-10-16 11:30:00','2020-10-16 12:43:00','2','14'),
('2','2020-10-16 9:45:00','2020-10-16 10:36:00','14','6'),
('5','2020-10-16 9:45:00','2020-10-16 9:45:00','2','8'),
('9','2020-10-12 9:45:00','2020-10-12 11:31:00','15','10'),
('6','2020-09-23 10:45:00','2020-09-23 11:02:00','15','6'),
('1','2020-09-23 9:45:00','2020-09-23 12:23:00','2','8'),
('8','2020-09-23 13:45:00','2020-09-23 14:32:00','2','9'),
('9','2020-08-15 14:45:00','2020-08-15 15:15:00','14','11'),
('9','2020-08-16 13:30:00','2020-08-16 14:10:00','14','12'),
('3','2020-08-19 10:30:00','2020-08-19 11:14:00','2','9'),
('3','2020-08-23 9:45:00','2020-08-23 10:35:00','15','10'),
('5','2020-08-01 9:45:00','2020-08-01 11:36:00','2','6'),
('6','2020-07-02 14:30:00','2020-07-02 16:45:00','2','15'),
('8','2020-09-02 10:10:00','2020-09-02 11:41:00','2','7'),
('1','2020-10-03 12:45:00','2020-10-03 13:52:00','14','8'),
('1','2020-10-18 14:05:00','2020-10-18 15:14:00','15','15'),
('5','2020-09-24 12:45:00','2020-09-24 14:57:00','15','4'),
('3','2020-09-22 11:30:00','2020-09-22 12:43:00','2','14'),
('8','2020-08-21 9:45:00','2020-08-21 10:36:00','14','6'),
('9','2020-08-16 9:45:00','2020-08-16 10:00:00','2','8'),
('3','2020-09-12 9:45:00','2020-09-12 11:31:00','15','10'),
('2','2020-09-23 9:45:00','2020-09-23 10:45:00','15','6'),
('6','2020-09-23 12:45:00','2020-09-23 13:23:00','2','8'),
('4','2020-09-23 15:45:00','2020-09-23 16:32:00','2','9'),
('7','2020-08-15 15:16:00','2020-08-15 16:00:00','14','11'),
('8','2020-08-13 13:30:00','2020-08-13 14:10:00','14','12'),
('4','2020-08-11 10:30:00','2020-08-11 11:14:00','2','9'),
('3','2020-08-14 9:45:00','2020-08-14 10:35:00','15','10'),
('7','2020-10-01 9:45:00','2020-10-01 11:36:00','2','6'),
('2','2020-10-02 14:30:00','2020-10-02 16:45:00','2','15'),
('4','2020-09-06 10:10:00','2020-09-06 11:41:00','2','7'),
('3','2020-10-07 12:45:00','2020-10-07 13:52:00','14','8'),
('6','2020-10-19 14:05:00','2020-10-19 15:14:00','15','15'),
('8','2020-09-14 12:45:00','2020-09-14 14:57:00','15','4'),
('9','2020-09-12 11:30:00','2020-09-12 12:43:00','2','14'),
('9','2020-08-11 9:45:00','2020-08-11 10:36:00','14','6'),
('1','2020-08-06 9:45:00','2020-08-06 10:02:00','2','8'),
('2','2020-07-12 9:45:00','2020-07-12 11:31:00','15','10'),
('4','2020-09-10 9:45:00','2020-09-10 10:45:00','15','6'),
('5','2020-09-25 12:45:00','2020-09-25 13:23:00','2','8'),
('2','2020-09-28 15:45:00','2020-09-28 16:32:00','2','9'),
('5','2020-08-30 15:16:00','2020-08-30 16:00:00','14','11'),
('1','2020-08-11 13:30:00','2020-08-11 15:10:00','14','12'),
('7','2020-08-11 13:30:00','2020-08-11 14:14:00','2','9'),
('8','2020-07-14 9:45:00','2020-07-14 10:35:00','15','10');



INSERT INTO caretaker_shift (hall_id, worker_id, time_start, time_end, week_day) VALUES
('1','2','09:45','12:00','Monday'),
('2','8','09:45','12:00','Monday'),
('3','12','09:45','12:00','Monday'),
('4','13','09:45','12:00','Monday'),
('5','16','09:45','12:00','Monday'),
('6','17','09:45','12:00','Monday'),
('7','18','09:45','12:00','Monday'),
('8','19','09:45','12:00','Monday'),
('9','20','09:45','12:00','Monday'),
('10','21','09:45','12:00','Monday'),
('11','22','09:45','12:00','Monday'),
('1','22','12:00','14:00','Monday'),
('2','2','12:00','14:00','Monday'),
('3','8','12:00','14:00','Monday'),
('4','12','12:00','14:00','Monday'),
('5','13','12:00','14:00','Monday'),
('6','16','12:00','14:00','Monday'),
('7','17','12:00','14:00','Monday'),
('8','18','12:00','14:00','Monday'),
('9','19','12:00','14:00','Monday'),
('10','20','12:00','14:00','Monday'),
('11','21','12:00','14:00','Monday'),
('1','21','14:00','16:00','Monday'),
('2','22','14:00','16:00','Monday'),
('3','2','14:00','16:00','Monday'),
('4','8','14:00','16:00','Monday'),
('5','12','14:00','16:00','Monday'),
('6','13','14:00','16:00','Monday'),
('7','16','14:00','16:00','Monday'),
('8','17','14:00','16:00','Monday'),
('9','18','14:00','16:00','Monday'),
('10','19','14:00','16:00','Monday'),
('11','20','14:00','16:00','Monday'),
('1','20','09:45','12:00','Wednesday'),
('2','21','09:45','12:00','Wednesday'),
('3','22','09:45','12:00','Wednesday'),
('4','2','09:45','12:00','Wednesday'),
('5','8','09:45','12:00','Wednesday'),
('6','12','09:45','12:00','Wednesday'),
('7','13','09:45','12:00','Wednesday'),
('8','16','09:45','12:00','Wednesday'),
('9','17','09:45','12:00','Wednesday'),
('10','18','09:45','12:00','Wednesday'),
('11','19','09:45','12:00','Wednesday'),
('1','19','12:00','14:00','Wednesday'),
('2','20','12:00','14:00','Wednesday'),
('3','21','12:00','14:00','Wednesday'),
('4','22','12:00','14:00','Wednesday'),
('5','2','12:00','14:00','Wednesday'),
('6','8','12:00','14:00','Wednesday'),
('7','12','12:00','14:00','Wednesday'),
('8','13','12:00','14:00','Wednesday'),
('9','16','12:00','14:00','Wednesday'),
('10','17','12:00','14:00','Wednesday'),
('11','18','12:00','14:00','Wednesday'),
('1','18','14:00','16:00','Wednesday'),
('2','19','14:00','16:00','Wednesday'),
('3','20','14:00','16:00','Wednesday'),
('4','21','14:00','16:00','Wednesday'),
('5','22','14:00','16:00','Wednesday'),
('6','2','14:00','16:00','Wednesday'),
('7','8','14:00','16:00','Wednesday'),
('8','12','14:00','16:00','Wednesday'),
('9','13','14:00','16:00','Wednesday'),
('10','16','14:00','16:00','Wednesday'),
('11','17','14:00','16:00','Wednesday'),
('1','17','09:45','12:00','Friday'),
('2','18','09:45','12:00','Friday'),
('3','19','09:45','12:00','Friday'),
('4','20','09:45','12:00','Friday'),
('5','21','09:45','12:00','Friday'),
('6','22','09:45','12:00','Friday'),
('7','2','09:45','12:00','Friday'),
('8','8','09:45','12:00','Friday'),
('9','12','09:45','12:00','Friday'),
('10','13','09:45','12:00','Friday'),
('11','16','09:45','12:00','Friday'),
('1','16','12:00','14:00','Friday'),
('2','17','12:00','14:00','Friday'),
('3','18','12:00','14:00','Friday'),
('4','19','12:00','14:00','Friday'),
('5','20','12:00','14:00','Friday'),
('6','21','12:00','14:00','Friday'),
('7','22','12:00','14:00','Friday'),
('8','2','12:00','14:00','Friday'),
('9','8','12:00','14:00','Friday'),
('10','12','12:00','14:00','Friday'),
('11','13','12:00','14:00','Friday'),
('1','13','14:00','16:00','Friday'),
('2','16','14:00','16:00','Friday'),
('3','17','14:00','16:00','Friday'),
('4','18','14:00','16:00','Friday'),
('5','19','14:00','16:00','Friday'),
('6','20','14:00','16:00','Friday'),
('7','21','14:00','16:00','Friday'),
('8','22','14:00','16:00','Friday'),
('9','2','14:00','16:00','Friday'),
('10','8','14:00','16:00','Friday'),
('11','12','14:00','16:00','Friday');





ALTER TABLE exhibit
ADD FOREIGN KEY (hall_id) REFERENCES hall (id);

ALTER TABLE worker
ADD FOREIGN KEY (position_id) REFERENCES position (id);

ALTER TABLE excursion_hall
ADD FOREIGN KEY (excursion_type_id) REFERENCES excursion_type (id),
ADD FOREIGN KEY (hall_id) REFERENCES hall (id);

ALTER TABLE excursion
ADD FOREIGN KEY (excursion_type_id) REFERENCES excursion_type (id),
ADD FOREIGN KEY (worker_id) REFERENCES worker (id);

ALTER TABLE caretaker_shift
ADD FOREIGN KEY (hall_id) REFERENCES hall (id),
ADD FOREIGN KEY (worker_id) REFERENCES worker (id);
