-- Brisanja iz baze Knjiznica

-- brisanje pojedinog zapisa (redka) u tablici 
DELETE FROM clanovi WHERE clanovi.id = 4;

-- brisanje atributa (column) iz posojece tablice
ALTER TABLE clanovi DROP COLUMN datum_rodjenja;

-- brisanje indeksa u tablici
ALTER TABLE clanovi DROP INDEX email;

-- brisanje cijele tablice 
DROP TABLE clanovi;

-- brisanje cijele baze
DROP DATABASE knjiznica;

-- isprazniti tablicu posudbe
TRUNCATE posudbe;

-- obrisati strani kljuc
ALTER TABLE knjige DROP FOREIGN KEY knjige_ibfk_1;

-- kreiranje starnog kljuca sa uvjetom ON DELETE CASCADE
ALTER TABLE knjige ADD FOREIGN KEY (zanr_id) REFERENCES zanrovi(id) ON DELETE CASCADE;

-- promjena vrijednosti u postojecim zapisima
UPDATE clanovi SET prezime = 'Dobrinic', ime = 'Aleks' WHERE id = 8;
UPDATE clanovi SET datum_clanstva = CURDATE() WHERE id = 8;