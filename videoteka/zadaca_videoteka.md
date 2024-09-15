### Baza podataka za poslovanje jedne videoteke.
- Kreirajte ER dijagram za poslovanje jedne videoteke.
- Videoteka članovima izdaje članske iskaznice te se na temelju članskog broja osoba identificira kako bi mogla posuditi filmove.
- Filmovi su složeni po žanrovima.
- Videoteka ima definiran cjenik za izdavanje hit filma, film koji nije hit te starog filma.
- Jedan film može biti na DVD-u, BlueRay-u ili VHS-u.
- Film se posđuje na rok od jednog dana I ako ga član ne vrati u navedeno vrijeme, zaračunava mu se zakasnina.

### Dopuna zadace
- kreirajte novo korisnika u MySQL-u i dajte mu povlastice samo za bazu videoteka
```sql
CREATE USER 'novi'@'localhost' IDENTIFIED BY 'novi';
GRANT ALL PRIVILEGES ON videoteka.* TO 'novi'@'localhost';
FLUSH PRIVILEGES;
```
- Svaki film ima zalihu dostupnih kopija po mediju za koji je dostupan
- Svaka fizicka kopija filma ima svoj jedinstveni identifikacijski broj (s/n) kako bi se mogla pratiti
```sql
ALTER TABLE posudba DROP FOREIGN KEY posudba_ibfk_2;
ALTER TABLE posudba DROP COLUMN zaliha_id;
DROP TABLE IF EXISTS zaliha;

CREATE TABLE IF NOT EXISTS kopija (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    barcode VARCHAR(50) NOT NULL,
    dostupan BOOLEAN DEFAULT TRUE,
    film_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (film_id) REFERENCES filmovi(id),
    medij_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (medij_id) REFERENCES mediji(id),
    UNIQUE(id, barcode)
) ENGINE=InnoDB;

INSERT INTO kopija (barcode, dostupan, film_id, medij_id)
VALUES 
('INCEPTDVD', TRUE, 1, 1),
('INCEPTDVD', TRUE, 1, 1),
('INCEPTDVD', TRUE, 1, 1),
('INCEPTBLURAY', TRUE, 1, 2),
('INCEPTBLURAY', TRUE, 1, 2),
('INCEPTVHS', TRUE, 1, 3),
('INCEPTVHS', TRUE, 1, 3),
('KUMDVD', TRUE, 2, 1),
('KUMDVD', TRUE, 2, 1),
('KUMBLURAY', TRUE, 2, 2),
('KUMBLURAY', TRUE, 2, 2);
```

- Clan od jednom moze posuditi vise od jednog filma

```sql
CREATE TABLE IF NOT EXISTS posudba_kopija (
    posudba_id INT UNSIGNED NOT NULL,
    kopija_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (posudba_id) REFERENCES posudba(id),
    FOREIGN KEY (kopija_id) REFERENCES kopija(id)
) ENGINE=InnoDB;

INSERT INTO posudba_kopija (posudba_id, kopija_id)
VALUES 
(1, 1),
(1, 3),
(2, 6),
(2, 8);