/*
fichier createTablesMYSQL.sql
Numero 21509841, Dautheribes, Jérémie
Numero 21505680, Soussi, Wissem
*/

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

-- Blocage/Deblocage d'un inscrit avec une date de fin blocage
CREATE PROCEDURE Blockage_Membre
(IN adminMail VARCHAR(200),IN motDePass VARCHAR(26), IN emailBloque VARCHAR(200), dateFinBlockageP DATE)
BEGIN
DECLARE Admin BOOLEAN;
SELECT count(*) INTO Admin FROM inscrit WHERE adminMail = email AND motDePass = mdp AND estAdmin = true;
IF (Admin) THEN
    UPDATE inscrit SET dateFinBlockage = dateFinBlockageP WHERE email = emailBloque;
END IF;
END//

-- création de trajet type (sous les contraintes des triggers dans le fichier triggersMysql.sql)
INSERT INTO trajet_type(prixParKm, villeDepX, villeDepY, villeArrX, villeArrY, email_admin)
VALUES ("value", "value", "value", "value", "value", "value");

-- ajout d'une ville
INSERT INTO ville(coordX,coordY,nom,pays,region)
VALUES ("value","value", "value", "value", "value");
