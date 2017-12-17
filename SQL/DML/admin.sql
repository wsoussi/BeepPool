-- modification d'un membre en admin
CREATE PROCEDURE Promotion_Membre
(IN adminMail VARCHAR(200), IN motDePass VARCHAR(26), IN emailPromotionReceiver VARCHAR(200))
BEGIN
DECLARE Admin TINYINT DEFAULT 0;
SELECT count(*) INTO Admin FROM inscrit WHERE adminMail = email AND motDePass = mdp AND estAdmin = true;
IF (Admin = 1) THEN
    UPDATE inscrit SET estAdmin = 1 WHERE email = emailPromotionReceiver;
END IF;
END//

-- Blockage/Deblockage d'un inscrit avec une date de fin blockage
CREATE PROCEDURE Blockage_Membre
(IN adminMail VARCHAR(200),IN motDePass VARCHAR(26), IN emailBloque VARCHAR(200), dateFinBlockageP DATE)
BEGIN
DECLARE Admin BOOLEAN;
SELECT count(*) INTO Admin FROM inscrit WHERE adminMail = email AND motDePass = mdp AND estAdmin = true;
IF (Admin) THEN
    UPDATE inscrit SET dateFinBlockage = dateFinBlockageP WHERE email = emailBloque;
END IF;
END//

-- Exemple de création de trajet type
-- (sous les contraintes des triggers dans le fichier triggersMysql.sql)
INSERT INTO trajet_type(prixParKm, villeDepX, villeDepY, villeArrX, villeArrY, email_admin)
VALUES (0.1,3.8772300,43.6109200, 7.017369, 43.552847, 'wissem.soussi@etu.umontpellier.fr');
