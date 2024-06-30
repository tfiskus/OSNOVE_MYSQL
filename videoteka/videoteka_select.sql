/* Dohvati sve (zapise i polja) podatke iz tablice filmovi */
SELECT * from filmovi;
/* Dohvati sve (zapise i polja) podatke iz tablice clanovi */
SELECT * from clanovi;

-- dohvati polja naslov, godina iz tablice filmov
SELECT naslov AS Naslov, godina AS "Godina izavanja" from filmovi;

-- dohvati samo prvi zapis iz tablice filmovi
SELECT * from filmovi WHERE id=1;

-- dohvati zapis iz tablice filmovi gdje je naslov Inception
SELECT * from filmovi WHERE naslov='Inception';

-- dohvati zapise iz tablice filmovi gdje je ID 2 ili 3
SELECT * from filmovi WHERE id=2 OR id=3;
SELECT * from filmovi WHERE id IN (2,3);

-- dohvati zapise iz tablice clanovi gdje je ime Ivan i telefon je 0912345678
SELECT * from clanovi WHERE ime="Ivan Horvat" AND telefon='0912345678';

SELECT * from filmovi WHERE (id=1 OR id=2) AND naslov='Kum';

-- dohvati zapise iz tablice filmovi gdje je film noviji od godine 1990
SELECT * from filmovi WHERE godina >= 1990;

-- dohvati zapise iz tablice filmovi gdje je film id razlicit od 2
SELECT * from filmovi WHERE id != 2;

-- poredaj filmove po godinama uzlazno
SELECT * from filmovi ORDER BY godina ASC;

-- poredaj filmove po godinama silazno
SELECT * from filmovi ORDER BY godina DESC;

-- pretrazi tablicu filmovi po naslovu filma
SELECT * from filmovi WHERE naslov LIKE "%nceptio%";

-- count, avg, sum
SELECT count(id) AS "Broj filmova u bazi" from filmovi;
SELECT count(id) AS "Broj filmova u bazi mladjih od 24 godine" from filmovi WHERE godina > 1990;

SELECT avg(cijena) AS 'Prosjek cijene' from cjenik;
SELECT format(avg(cijena), 2) AS 'Prosjek cijene formatiran' from cjenik;

SELECT sum(cijena) AS 'Ukupna cijena' from cjenik;

-- spoji tablice filmovi i zanrovi kako bi u rezultatu dobio skupljene podatke iz obje tablice
SELECT f.naslov, f.godina, z.ime AS 'Zanr'
    from filmovi f
    JOIN zanrovi z ON f.zanr_id = z.id;

-- spoji tablice filmovi, zanrovi i cjenik kako bi u rezultatu dobio skupljene podatke iz sve tri tablice
SELECT f.naslov, f.godina, z.ime AS 'Zanr', c.tip_filma AS 'Tip', c.cijena, c.zakasnina_po_danu AS 'Zakasnina'
    from filmovi f
    JOIN zanrovi z ON f.zanr_id = z.id
    JOIN cjenik c ON f.cjenik_id = c.id;

-- spoji tablice posudba sa filmovi i mediji preko vezne tablice zaliha
SELECT p.datum_posudbe, p.datum_povrata, c.ime, f.naslov, m.tip
    from posudba p
    JOIN clanovi c ON p.clan_id = c.id
    JOIN zaliha z ON p.zaliha_id = z.id
    JOIN filmovi f ON z.film_id = f.id
    JOIN mediji m ON z.medij_id = m.id;

-- izlistaj posube i film naziv i medij za filmove koji nisu vraceni
SELECT p.datum_posudbe, p.datum_povrata, c.ime, f.naslov, m.tip
    from posudba p
    JOIN clanovi c ON p.clan_id = c.id
    JOIN zaliha z ON p.zaliha_id = z.id
    JOIN filmovi f ON z.film_id = f.id
    JOIN mediji m ON z.medij_id = m.id
    WHERE p.datum_povrata IS NULL;


-- povezi sve tablice i izlistaj podatke
SELECT
    p.datum_posudbe,
    p.datum_povrata,
    c.ime AS "Ime Clana",
    f.naslov,
    m.tip AS Medij,
    zanrovi.ime AS Zanr,
    cj.tip_filma,
    ROUND(cj.cijena * m.koeficijent, 2) AS Cijena,
    ROUND(cj.zakasnina_po_danu * m.koeficijent, 2) AS Zakasnina
from
    posudba p
    JOIN clanovi c ON p.clan_id = c.id
    JOIN zaliha z ON p.zaliha_id = z.id
    JOIN filmovi f ON z.film_id = f.id
    JOIN mediji m ON z.medij_id = m.id
    JOIN zanrovi ON zanrovi.id = f.zanr_id
    JOIN cjenik cj ON cj.id = f.cjenik_id;

-- ispisi clanove koji su posudili vise od jednog filma
SELECT c.ime
    FROM clanovi c
JOIN posudba p ON p.clan_id = c.id
    GROUP BY c.ime
HAVING COUNT(c.id) > 1;

-- GROUP BY - ispisite totalnu kolicinu kopija dostupnih po filmu (zbroj svih medija)
SELECT f.*, SUM(z.kolicina) AS 'Ukupna Kolicaina'
	from filmovi f
    JOIN zaliha z ON z.film_id = f.id
    GROUP BY f.id;

-- HAVING - filtrirajte gornji upit da izlista samo filmove koji imaju vise od 10 kopija
SELECT f.*, SUM(z.kolicina) AS ukupna_kolicaina
	from filmovi f
    JOIN zaliha z ON z.film_id = f.id
    GROUP BY f.id
    HAVING ukupna_kolicaina > 10;

-- Subquery (Podupit)
-- Dohvati sve filmove koji imaju kolicinu na BlueRay-u
SELECT filmovi.ime from filmovi WHERE IN (1,3,4);
SELECT film_id from zaliha z JOIN mediji m ON z.medij_id = m.id WHERE m.tip = "Blu-Ray";

-- podupit
SELECT filmovi.naslov from filmovi WHERE filmovi.id IN (
    SELECT film_id from zaliha z JOIN mediji m ON z.medij_id = m.id WHERE m.tip = "Blu-Ray"
);

-- dohvati clanove koji imaju ne vracen film proko jednog dana (zakasnina)
SELECT c.*, datediff(p.datum_povrata, p.datum_posudbe)-1 AS 'Zakasnina'
    from posudba p 
    JOIN clanovi c ON c.id = p.clan_id
WHERE datediff(p.datum_povrata, p.datum_posudbe) > 1 OR (p.datum_povrata IS NULL AND datediff(CURRENT_DATE, p.datum_posudbe) > 1);

-- dohvati sve iz filmova, preskoci prva dva zapisa, dohvati sveukupno 3 zapisa
SELECT * from filmovi LIMIT 2 OFFSET 2;

-- dohvati prosjecnu cijenu filmova s obzirom na ukupnu zalihu filmova 