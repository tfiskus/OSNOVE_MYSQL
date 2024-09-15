DROP DATABASE IF EXISTS videoteka;

CREATE DATABASE IF NOT EXISTS videoteka DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE videoteka;

CREATE TABLE IF NOT EXISTS zanrovi (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ime VARCHAR(100) NOT NULL UNIQUE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cjenik (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    tip_filma VARCHAR(20) NOT NULL,
    cijena DECIMAL(10,2) NOT NULL,
    zakasnina_po_danu DECIMAL(10,2) NOT NULL,
    UNIQUE (tip_filma)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS filmovi (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    naslov VARCHAR(100) NOT NULL,
    godina CHAR(4) NOT NULL,
    zanr_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (zanr_id) REFERENCES zanrovi(id),
    cjenik_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (cjenik_id) REFERENCES cjenik(id)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS mediji (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    tip VARCHAR(100) NOT NULL,
    koeficijent FLOAT NOT NULL,
    UNIQUE (tip)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS clanovi (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ime VARCHAR(100) NOT NULL,
    adresa VARCHAR(100),
    telefon VARCHAR(12),
    email VARCHAR(50) NOT NULL UNIQUE,
    clanski_broj CHAR(14) NOT NULL UNIQUE
)ENGINE=InnoDB;

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

CREATE TABLE IF NOT EXISTS posudba (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    datum_posudbe DATE NOT NULL,
    datum_povrata DATE,
    clan_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (clan_id) REFERENCES clanovi(id),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS posudba_kopija (
    posudba_id INT UNSIGNED NOT NULL,
    kopija_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (posudba_id) REFERENCES posudba(id),
    FOREIGN KEY (kopija_id) REFERENCES kopija(id)
) ENGINE=InnoDB;

INSERT INTO zanrovi (ime) VALUES 
('Akcija'), 
('Komedija'), 
('Drama'), 
('Horor'), 
('Romantika');

INSERT INTO cjenik (tip_filma, cijena, zakasnina_po_danu) VALUES 
('Hit', 5.00, 1.00), 
('Ne-hit', 3.00, 0.50), 
('Stari', 1.50, 0.25);

INSERT INTO mediji (tip, koeficijent) VALUES 
('DVD', 1.0), 
('Blu-ray', 1.5), 
('VHS', 0.8);

INSERT INTO filmovi (naslov, godina, zanr_id, cjenik_id) VALUES 
('Inception', '2010', 1, 1),
('Kum', '1972', 3, 2),
('Ralje', '1975', 4, 2),
('Titanic', '1997', 5, 3),
('Matrix', '1999', 1, 1),
('Deadpool 2', '2018', 2, 2);

INSERT INTO kopija (barcode, dostupan, film_id, medij_id)
VALUES 
('INCEPTDVD', TRUE, 1, 1),
('INCEPTDVD', TRUE, 1, 1),
('INCEPTDVD', TRUE, 1, 1),
('INCEPTBLURAY', FALSE, 1, 2),
('INCEPTBLURAY', TRUE, 1, 2),
('INCEPTVHS', TRUE, 1, 3),
('INCEPTVHS', TRUE, 1, 3),
('KUMDVD', TRUE, 2, 1),
('KUMDVD', TRUE, 2, 1),
('KUMBLURAY', FALSE, 2, 2),
('KUMBLURAY', TRUE, 2, 2),
('RALJEDVD', TRUE, 3, 1),
('RALJEBR', TRUE, 3, 2),
('RALJEBR', TRUE, 3, 2),
('RALJEVHS', TRUE, 3, 3),
('RALJEVHS', TRUE, 3, 3),
('RALJEVHS', TRUE, 3, 3),
('TITANICDVD', TRUE, 4, 1),
('TITANICDVD', TRUE, 4, 1),
('TITANICDVD', FALSE, 4, 1),
('TITANICDVD', FALSE, 4, 1),
('TITANICBR', TRUE, 4, 2),
('TITANICBR', TRUE, 4, 2),
('MATRIXDVD', TRUE, 5, 1),
('MATRIXDVD', TRUE, 5, 1),
('MATRIXBR', TRUE, 5, 2),
('DEAD2DVD', TRUE, 6, 1),
('DEAD2DVD', FALSE, 6, 1),
('DEAD2DVD', FALSE, 6, 1),
('DEAD2DVD', TRUE, 6, 1),
('DEAD2BLURAY', TRUE, 6, 2),
('DEAD2BLURAY', TRUE, 6, 2);

INSERT INTO clanovi (ime, adresa, telefon, email, clanski_broj) VALUES 
('Ivan Horvat', 'Ulica Kralja Zvonimira 10', '0912345678', 'ivan.horvat@example.com', 'CLAN12345'),
('Ana Kovač', 'Ulica Matije Gupca 15', '0912345679', 'ana.kovac@example.com', 'CLAN12346'),
('Marko Maric', 'Ulica Ivana Gundulića 5', '0912345680', 'marko.maric@example.com', 'CLAN12347'),
('Petra Novak', 'Ulica Stjepana Radića 8', '0912345681', 'petra.novak@example.com', 'CLAN12348');

INSERT INTO posudba (datum_posudbe, datum_povrata, clan_id) VALUES 
('2024-06-09', '2024-06-13', 1), -- tri dana zakasnine
('2024-06-12', '2024-06-13', 2), -- nema zakasnine
('2024-06-12', '2024-06-15', 3), -- dva dana zakasnine
('2024-06-15', '2024-06-17', 4); -- jedan dan zakasnine

INSERT INTO posudba_kopija (posudba_id, kopija_id)
VALUES 
(1, 1),
(1, 12),
(2, 6),
(2, 15),
(3, 4),
(4, 11);