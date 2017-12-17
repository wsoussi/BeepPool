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
(IN depX DECIMAL(9,6),IN depY DECIMAL(9,6), IN arrX DECIMAL(9,6), IN arrY DECIMAL(9,6), OUT resultat INTEGER UNSIGNED )
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
(IN depX DECIMAL(9,6),IN depY DECIMAL(9,6), IN arrX DECIMAL(9,6), IN arrY DECIMAL(9,6), OUT resultat INTEGER)
BEGIN

DECLARE numTTR INTEGER DEFAULT -1;

SELECT numTT INTO numTTR FROM trajet_type
WHERE (villeDepX = depX AND villeDepY = depY)
AND (villeArrX = arrX AND villeArrY = arrY);

SET resultat = numTTR;

END//


-- Procédure pour calculer la distance entre deux ville
CREATE PROCEDURE calcul_distance
(IN depX DECIMAL(9,6),IN depY DECIMAL(9,6), IN arrX DECIMAL(9,6), IN arrY DECIMAL(9,6), OUT resultat DECIMAL(6,2))
BEGIN
DECLARE R DECIMAL(13,9);
DECLARE latA DECIMAL(13,9);
DECLARE latB DECIMAL(13,9);
DECLARE lonA DECIMAL(13,9);
DECLARE lonB DECIMAL(13,9);
SET R = 6372.795477598;
SET latA = depY/180*PI();
SET latB = arrY/180*PI();
SET lonA = depX/180*PI();
SET lonB = arrX/180*PI();
SET resultat = R * ACOS( SIN(latA) * SIN(latB) +
COS(latA) * COS(latB) * COS(lonA - lonB));
END//

-- Procédure calcul prix au kilomètre
CREATE PROCEDURE calcul_prix_par_km
(IN distance DECIMAL(6,2), IN prix DECIMAL(5,2), OUT resultat DECIMAL(3,2))
BEGIN
    SET resultat = ( prix/distance );
END//

-- Procédure calcul temps moyen d'un trajet
CREATE PROCEDURE calcul_temps_par_trajet
(IN distance DECIMAL(6,2),OUT resultat TIME)
BEGIN
DECLARE hours INTEGER;
DECLARE minutes INTEGER;
SET hours = TRUNCATE(distance/90,0);
SET minutes = (distance/90*100 - hours*100)/10*6;
    SET resultat = hours*10000 + minutes*100;
END//
