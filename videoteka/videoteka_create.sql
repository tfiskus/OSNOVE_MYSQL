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

CREATE TABLE IF NOT EXISTS zaliha (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    film_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (film_id) REFERENCES filmovi(id),
    medij_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (medij_id) REFERENCES mediji(id),
    kolicina INT NOT NULL
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS posudba (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    datum_posudbe DATE NOT NULL,
    datum_povrata DATE,
    clan_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (clan_id) REFERENCES clanovi(id),
    zaliha_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (zaliha_id) REFERENCES zaliha(id)
)ENGINE=InnoDB;