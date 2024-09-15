-- dohvati kolicinu svih filmova na DVD-u
SELECT f.naslov, count(f.id) AS 'Broj kopija na DVD-u'
    FROM kopija k
    JOIN filmovi f ON k.film_id = f.id
    JOIN mediji m ON k.medij_id = m.id
    WHERE m.tip = 'DVD' AND k.dostupan = 1
    GROUP BY f.id;

-- dohvati kolicinu filmova po svakom mediju za film ID=1
SELECT f.naslov, concat(m.tip, ' ', count(f.id)) AS 'Broj kopija'
    FROM kopija k
    JOIN filmovi f ON k.film_id = f.id
    JOIN mediji m ON k.medij_id = m.id
    WHERE f.id = 1 AND k.dostupan = 1
    GROUP BY m.id;

-- za svaki film u bazi dohvatiti kolicinu filmova po mediju
SELECT f.naslov, m.tip, COUNT(f.id) AS 'kolicina'
	FROM kopija k
	JOIN filmovi f ON k.film_id = f.id
    JOIN mediji m ON k.medij_id = m.id
    WHERE k.dostupan = 1
    GROUP BY f.naslov, m.tip; 


-- dohvati prosječnu cijenu filmova s obzirom na ukupnu zalihu filmova
SELECT f.naslov, COUNT(k.id) AS 'Broj kopija', ROUND(AVG(c.cijena * m.koeficijent), 2) AS prosjecna_cijena
    FROM kopija k
    JOIN filmovi f ON k.film_id = f.id
    JOIN cjenik c ON c.id = f.cjenik_id
    JOIN mediji m ON k.medij_id = m.id
    WHERE k.dostupan = 1
    GROUP BY f.id;

-- izlistai posudbe sa clan.ime i film.naziv
SELECT p.*, c.ime, IFNULL(f.naslov, 'Nije posudio Nista') AS posudio
    FROM posudba p 
    JOIN clanovi c ON c.id = p.clan_id
    LEFT JOIN posudba_kopija pk ON p.id = pk.posudba_id
    LEFT JOIN kopija k ON pk.kopija_id = k.id
    LEFT JOIN filmovi f ON k.film_id = f.id;

-- korisetnje IF funkcije
SELECT
    f.naslov,
    m.tip,
    COUNT(k.id) AS 'Broj kopija',
    IF(
        COUNT(k.id) > 2,
        'Dovoljno na zalihi',
        'Nedovoljno na zalihi'
    )
FROM
    kopija k
    JOIN filmovi f ON k.film_id = f.id
    JOIN mediji m ON k.medij_id = m.id
GROUP BY
    f.id,
    m.id
ORDER By
    f.naslov;

-- korisetnje CASE strukture toka
SELECT
    f.naslov,
    m.tip,
    COUNT(k.id) AS broj_kopija,
  	CASE
    	WHEN COUNT(k.id) = 0 THEN 'Nema na zalihi'
        WHEN COUNT(k.id) <= 2 THEN 'Malo'
        WHEN COUNT(k.id) > 2 THEN 'Dovoljno'
        ELSE 'Default'
     END AS Stanje
FROM
    kopija k
    JOIN filmovi f ON k.film_id = f.id
    JOIN mediji m ON k.medij_id = m.id
GROUP BY
    f.id,
    m.id
ORDER By
    f.naslov;



SELECT
    MAX(dostupne_kopije) AS najvise_kopija,
    MAX(godina_filma) AS najnovija_godina
FROM
    available_movies;


SELECT
    REPLACE(adresa, ' ', '_') AS adresa_replaced
FROM
    clanovi;



SELECT
    NOW() AS trenutno_vrijeme_datum,
    CURTIME() AS trenutno_vrijeme,
    CURDATE() AS trenutni_datum,
    CURRENT_TIMESTAMP;



SELECT
    DATE_FORMAT(p.datum_posudbe, '%d.%m.%Y.') AS formatirani_datum_posudbe,
    MONTHNAME(p.datum_posudbe) AS ime_mjeseca,
    MONTH(p.datum_posudbe) AS mjesec,
    YEAR(p.datum_posudbe) AS godina,
    DATE(p.datum_posudbe) AS datum,
    TIME(p.updated_at) AS vrijeme,
    DAY(p.updated_at) AS dan,
    HOUR(p.updated_at) AS sat,
    MINUTE(p.updated_at) AS minuta,
    SECOND(p.updated_at) AS sekunda,
    DATEDIFF(p.updated_at, p.datum_posudbe) AS datum_vece_manje,
    DATEDIFF(p.datum_posudbe, p.updated_at) AS datum_manje_vece,
    DATE_ADD(p.datum_posudbe, INTERVAL 1 DAY) AS dodaj_dan,
    DATE_SUB(p.datum_posudbe, INTERVAL 1 MONTH) AS oduzmi_mjesec,
    TIMESTAMPDIFF(MINUTE, p.updated_at, NOW()) razlika_u_minutama
FROM
    posudba p;