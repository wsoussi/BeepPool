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


-- Ajouter trajet si il est inscrit et pas blocke'
BEGIN
DECLARE
  IF NOT isBlocked('email') THEN
      INSERT INTO trajet VALUES (prix, date_dep , date_ar , adr_rdv , adr_dep , nbPlace , conducteur , vehiculeImm , villeDepX , villeDepY , villeArrX , villeArrY, numTrajetType )
                                ('prix', 'date_dep' , 'date_ar' , 'adr_rdv' , 'adr_dep' , 'nbPlace' , 'conducteur' , 'vehiculeImm' , 'villeDepX' , 'villeDepY' , 'villeArrX' , 'villeArrY', 'numTrajetType')
  END IF
END//

-- Changer le trajet si il est inscrit et pas blocke'

DECLARE

BEGIN
  IF NOT isBlocked('email') THEN
      UPDATE trajet SET .... WHERE conducteur = 'email' and numT= 'numTCible';
  END IF
END//

-- Laisser un avis, vérifie s'il est conducteur ou covoitueur
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
