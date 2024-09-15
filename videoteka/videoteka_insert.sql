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
('Matrix', '1999', 1, 1);

INSERT INTO zaliha (film_id, medij_id, kolicina) VALUES 
(1, 1, 5),
(1, 2, 2),
(1, 3, 12),
(2, 3, 3),
(3, 1, 10),
(3, 2, 20),
(4, 2, 4),
(5, 1, 6);

INSERT INTO clanovi (ime, adresa, telefon, email, clanski_broj) VALUES 
('Ivan Horvat', 'Ulica Kralja Zvonimira 10', '0912345678', 'ivan.horvat@example.com', 'CLAN12345'),
('Ana Kovač', 'Ulica Matije Gupca 15', '0912345679', 'ana.kovac@example.com', 'CLAN12346'),
('Marko Maric', 'Ulica Ivana Gundulića 5', '0912345680', 'marko.maric@example.com', 'CLAN12347'),
('Petra Novak', 'Ulica Stjepana Radića 8', '0912345681', 'petra.novak@example.com', 'CLAN12348');

INSERT INTO posudba (datum_posudbe, datum_povrata, clan_id, zaliha_id) VALUES 
('2024-06-09', '2024-06-13', 1, 1), -- tri dana zakasnine
('2024-06-12', '2024-06-13', 2, 3), -- nema zakasnine
('2024-06-12', '2024-06-15', 3, 5), -- dva dana zakasnine
('2024-06-15', '2024-06-17', 4, 2); -- jedan dan zakasnine