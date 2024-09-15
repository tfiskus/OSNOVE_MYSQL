-- procedura za stvaranje nove posudbe
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS create_posudba(
    IN p_clan_id INT UNSIGNED,
    IN p_kopija_id INT UNSIGNED
)
BEGIN
    DECLARE v_posudba_id INT UNSIGNED;
    DECLARE v_kolicina INT;

    -- Start transaction
    START TRANSACTION;

    -- Ensure the film copy is available
    SELECT count(f.id)
        INTO v_kolicina
        FROM kopija k
        JOIN filmovi f ON k.film_id = f.id
        JOIN mediji m ON k.medij_id = m.id
        WHERE m.tip = 'DVD'
            AND k.dostupan = 1
            AND f.naslov = 'Inception'
        GROUP BY f.id
        FOR UPDATE; -- race condition

    IF v_kolicina > 0 THEN
        -- Insert the new borrowing record
        INSERT INTO posudba (datum_posudbe, clan_id)
        VALUES (CURDATE(), p_clan_id);

        SET v_posudba_id = LAST_INSERT_ID();

        -- Insert the kopija into posudba_kopija
        INSERT INTO posudba_kopija (posudba_id, kopija_id)
        VALUES (v_posudba_id, p_kopija_id);

        -- Update the availability of the kopija
        UPDATE kopija
        SET dostupan = 0
        WHERE id = p_kopija_id;

        -- Commit the transaction
        COMMIT;
    ELSE
        -- If a film copy is not available, rollback the transaction
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock available';
    END IF;
END $$

DELIMITER ;

-- (clan_id, kopija_id) 
CALL create_posudba(1, 2);





-- procedura za popravak stanja dostupnih kopija filma u odnosu na posudbe
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS update_kopija()
BEGIN
    UPDATE kopija
    SET dostupan = 0
    WHERE id IN (
        SELECT kopija_id
        FROM posudba_kopija
    );
END $$

DELIMITER ;

CALL update_kopija();





-- procedura za ispis prosjecne cijene filma
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS calculate_prosjecna_cijena()
BEGIN
    SELECT
        f.naslov,
        COUNT(k.id) AS 'Broj kopija',
        ROUND(AVG(CASE WHEN k.dostupan = 1 THEN  c.cijena * m.koeficijent END), 2) AS prosjecna_cijena_dostupan,
        ROUND(AVG(CASE WHEN k.dostupan = 0 THEN c.cijena * m.koeficijent END), 2) AS prosjecna_cijena_nedostupan
    FROM kopija k
        JOIN filmovi f ON k.film_id = f.id
        JOIN cjenik c ON c.id = f.cjenik_id
        JOIN mediji m ON k.medij_id = m.id
    GROUP BY f.id
    ORDER BY f.id;
END $$

DELIMITER ;

CALL calculate_prosjecna_cijena();