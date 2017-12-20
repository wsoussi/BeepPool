-- Si l'inscrit est blocke' RENVOYER VRAI
CREATE FUNCTION isBlocked (varEmail VARCHAR(200))
RETURNS TINYINT(1) UNSIGNED
BEGIN
DECLARE resultat TINYINT(1) UNSIGNED;
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
RETURN resultat;
END//

--vérifie s'il est conducteur du trajet
CREATE FUNCTION estConducteur
(var_email VARCHAR(200),var_num_trajet INTEGER)
RETURNS TINYINT(1) UNSIGNED
BEGIN
DECLARE var_resultat TINYINT(1) UNSIGNED;
DECLARE email_conducteur VARCHAR(200);
SELECT conducteur INTO email_conducteur
FROM trajet
WHERE trajet.numT = var_num_trajet;

IF email_conducteur = var_email THEN
    SET var_resultat = true;
ELSE
    SET var_resultat = false;
END IF;
RETURN var_resultat;
END//

--vérifie s'il est covoitureur du trajet
CREATE FUNCTION estCovoitureur
(var_email VARCHAR(200),var_num_trajet INTEGER)
RETURNS TINYINT(1) UNSIGNED
BEGIN
DECLARE nb TINYINT(1) DEFAULT 0;
SELECT count(*) INTO nb
FROM participer
WHERE participer.numT = var_num_trajet AND  participer.numCovoitureur = var_email;
IF (nb > 0) THEN
    RETURN true;
ELSE
    RETURN false;
END IF;
END//

-- Procédure pour savoir si un trajet fait parti d'un trajet type
CREATE FUNCTION trajetType
(depX DECIMAL(9,6),depY DECIMAL(9,6),arrX DECIMAL(9,6), arrY DECIMAL(9,6))
RETURNS INTEGER
BEGIN
DECLARE resultat INTEGER;
DECLARE numTTR INTEGER DEFAULT -1;

SELECT numTT INTO numTTR FROM trajet_type
WHERE (villeDepX = depX AND villeDepY = depY)
AND (villeArrX = arrX AND villeArrY = arrY);

SET resultat = numTTR;
RETURN resultat;
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

-- Fonction pour calculer la distance entre deux ville
CREATE FUNCTION calcul_distance
(depX DECIMAL(9,6),depY DECIMAL(9,6),arrX DECIMAL(9,6), arrY DECIMAL(9,6))
RETURNS DECIMAL(6,2)
BEGIN
DECLARE resultat DECIMAL(6,2);
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
RETURN resultat;
END//

-- Procédure calcul prix au kilomètre
CREATE FUNCTION calcul_prix_par_km
(distance DECIMAL(6,2), prix DECIMAL(5,2))
RETURNS DECIMAL(3,2)
BEGIN
DECLARE resultat DECIMAL(3,2);
    SET resultat = ( prix/distance );
RETURN resultat;
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
