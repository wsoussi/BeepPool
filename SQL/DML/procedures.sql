-- Si l'inscrit est blocke' RENVOYER VRAI
CREATE PROCEDURE isBlocked (IN varEmail VARCHAR(200), OUT resultat TINYINT(1) UNSIGNED)
BEGIN
DECLARE nb_email INT;
DECLARE dateB DATE;

SELECT count(*) INTO nb_email
FROM inscrit
WHERE email = varEmail;

IF (nb_email = 1) THEN
  SELECT dateFinBlockage INTO dateB
  FROM inscrit
  WHERE email = varEmail;

  IF (dateB > CURDATE()) THEN
      SET resultat = TRUE;
  ELSE
      SET resultat = FALSE;
  END IF;

ELSE
    SET resultat = TRUE;
END IF;

END//

-- Ajouter trajet si il est inscrit et pas blocke' (complete' en PHP)
BEGIN
  IF (NOT isBlocked('email')) THEN
      INSERT INTO trajet VALUES (prix, date_dep , date_ar , adr_rdv , adr_dep , nbPlace , conducteur , vehiculeImm , villeDepX , villeDepY , villeArrX , villeArrY, numTrajetType )
                                ('prix', 'date_dep' , 'date_ar' , 'adr_rdv' , 'adr_dep' , 'nbPlace' , 'conducteur' , 'vehiculeImm' , 'villeDepX' , 'villeDepY' , 'villeArrX' , 'villeArrY', 'numTrajetType')
  END IF
END//

-- Changer le trajet si il est inscrit et pas blocke' (complete' en PHP)
BEGIN
  IF (NOT isBlocked('email')) THEN
      UPDATE trajet SET .... WHERE conducteur = 'email' and numT= 'numTCible';
  END IF
END//

--vérifie s'il est conducteur ou covoitureur
CREATE PROCEDURE estConducteur
(IN var_email VARCHAR(200), IN var_num_trajet INTEGER, OUT var_resultat TINYINT(1) UNSIGNED )
BEGIN
DECLARE email_conducteur VARCHAR(200);
SELECT conducteur INTO email_conducteur
FROM trajet, inscrit, participer
WHERE trajet.numT = participer.numT AND  inscrit.email = trajet.conducteur
AND trajet.numT = var_num_trajet
AND participer.numCovoitureur = var_email;

IF email_conducteur = var_email THEN
    SET var_resultat = true;
ELSE
    SET var_resultat = false;
END IF;

END//

-- Procédure pour savoir si un trajet fait parti d'un trajet type
CREATE PROCEDURE estTrajetType
(IN depX DECIMAL,IN depY DECIMAL, IN arrX DECIMAL, IN arrY DECIMAL, OUT resultat INTEGER UNSIGNED )
BEGIN

DECLARE nbD INT;
DECLARE nbA INT;

SELECT count(*) INTO nbD FROM trajet_type
WHERE (villeDepX = depX OR villeArrX = depX)
AND (villeDepY = depY OR villeArrY = depY);

SELECT count(*) INTO nbA FROM trajet_type
WHERE (villeDepX = arrX OR villeArrX = arrX)
AND (villeDepY = arrY OR villeArrY = arrY);

IF nbD >= 1 AND nbA >= 1 THEN
    SET resultat = true;
ELSE
    SET resultat = false;
END IF;

END//

-- Procédure pour savoir si un trajet fait parti d'un trajet type
CREATE PROCEDURE trajetType
(IN depX DECIMAL,IN depY DECIMAL, IN arrX DECIMAL, IN arrY DECIMAL, OUT resultat INTEGER)
BEGIN

DECLARE numTTR INTEGER DEFAULT -1;

SELECT numTT INTO numTTR FROM trajet_type
WHERE (villeDepX = depX AND villeDepY = depY)
AND (villeArrX = arrX AND villeArrY = arrY);

SET resultat = numTTR;

END//


-- Procédure pour calculer la distance entre deux ville
CREATE PROCEDURE calcul_distance
(IN depX DECIMAL,IN depY DECIMAL, IN arrX DECIMAL, IN arrY DECIMAL, OUT resultat DECIMAL)
BEGIN
DECLARE R DECIMAL;

SET R = 6372.795477598;

SET resultat = R * ACOS( SIN(depY) * SIN(arrY) +
COS(depY) * COS(arrY) * COS(depX - arrX));

END//
