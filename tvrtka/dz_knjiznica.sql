SELECT
    CONCAT(clanovi.ime, " ", clanovi.prezime) AS Ime,
    knjige.naslov as Knjiga
FROM
    posudbe
    JOIN clanovi on posudbe.clan_id = clanovi.id
    JOIN kopija on posudbe.kopija_id = kopija.id
    JOIN knjige on kopija.knjiga_id = knjige.id

SELECT
    CONCAT(clanovi.ime, " ", clanovi.prezime) AS Clan,
    knjige.naslov
    posudbe.datum_posudbe,
    posudbe.datum_povrata,
FROM
    posudbe
    JOIN clanovi on posudbe.clan_id = clanovi.id
    JOIN kopija on posudbe.kopija_id = kopija.id
    JOIN knjige on kopija.knjiga_id = knjige.id
WHERE
    posudbe.datum_povrata IS NULL AND CURDATE() - posudbe.datum_posudbe > 14
    OR
    posudbe.datum_povrata - posudbe.datum_posudbe > 14;