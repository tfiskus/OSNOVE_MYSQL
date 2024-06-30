DELIMITER //

CREATE PROCEDURE create_posudba(IN p_clan_id INT, IN p_film_id INT, IN p_medij_id INT)
BEGIN
    DECLARE v_kolicina INT;
    DECLARE v_zaliha_id INT;

    -- Ensure the film is in stock
    SELECT kolicina INTO v_kolicina 
    FROM zaliha 
    WHERE film_id = p_film_id AND medij_id = p_medij_id 
    FOR UPDATE;

    -- Check if there is stock available
    IF v_kolicina > 0 THEN
        -- Retrieve the zaliha_id
        SELECT id INTO v_zaliha_id 
        FROM zaliha 
        WHERE film_id = p_film_id AND medij_id = p_medij_id 
        LIMIT 1;

        -- Insert the new borrowing record
        INSERT INTO posudba (datum_posudbe, datum_povrata, clan_id, zaliha_id) 
        VALUES (CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 DAY), p_clan_id, v_zaliha_id);

        -- Update the stock quantity
        UPDATE zaliha 
        SET kolicina = kolicina - 1 
        WHERE id = v_zaliha_id;

        COMMIT;
    ELSE
        -- If there is no stock available, rollback the transaction
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock available';
    END IF;
END //

DELIMITER ;

-- (clan_id, film_id, medij_id)
CALL create_posudba(1, 6, 2);