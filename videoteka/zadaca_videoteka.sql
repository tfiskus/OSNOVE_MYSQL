
--Dopuna zadace
--kreirajte novo korisnika u MySQL-u i dajte mu povlastice samo za bazu videoteka
--Svaki film ima zalihu dostupnih kopija po mediju za koji je dostupan
--Svaka fizicka kopija filma ima svoj jedinstveni identifikacijski broj (s/n) kako bi se mogla pratiti
--Clan od jednom moze posuditi vise od jednog filma

CREATE USER 'tfiskus'@'localhost' IDENTIFIED BY 'tfiskus';
GRANT ALL on videoteka.* TO 'tfiskus'@'localhost';
--REVOKE, DROP, FLUSH PRIVILEGIES (bozidar09)

CREATE TABLE IF NOT EXISTS film_kopija (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    film_id INT UNSIGNED NOT NULL,
    medij_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (film_id) REFERENCES filmovi(id),
    FOREIGN KEY (medij_id) REFERENCES mediji(id)
)ENGINE=InnoDB;






