-- create a new film with its associated stock (zaliha)
START TRANSACTION;

-- Insert the new film
INSERT INTO filmovi (naslov, godina, zanr_id, cjenik_id) 
VALUES ('Deadpool 3', '2024', 2, 2);

-- Get the last inserted film ID
SET @new_film_id = LAST_INSERT_ID();

-- Insert stock information
INSERT INTO kopija (barcode, dostupan, film_id, medij_id) 
VALUES 
('DEAD3DVD', 1, @new_film_id, 1), 
('DEAD3BR', 1, @new_film_id, 2),
('DEAD3VHS', 1, @new_film_id, 3);

COMMIT;