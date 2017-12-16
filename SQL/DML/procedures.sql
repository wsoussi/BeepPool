-- Si l'inscrit est blocke' RENVOYER VRAI
CREATE OR REPLACE PROCEDURE isBlocked
(var_email IN VARCHAR(200))
RETURN BOOLEAN IS
var_resultat BOOLEAN = false;
CURSOR C_bloques IS
  SELECT email
  FROM inscrit
  WHERE dateFinBlockage > getdate();
BEGIN
  FOR mail IN C_bloques LOOP
    IF var_email = mail THEN
      var_resultat = true;
    END IF;
  END LOOP;
  RETURN var_resultat;
END;
/

DECLARE

BEGIN
  IF NOT isBlocked('email') THEN
      INSERT INTO trajet VALUES (prix, date_dep , date_ar , adr_rdv , adr_dep , nbPlace , conducteur , vehiculeImm , villeDepX , villeDepY , villeArrX , villeArrY, numTrajetType )
                                ('prix', 'date_dep' , 'date_ar' , 'adr_rdv' , 'adr_dep' , 'nbPlace' , 'conducteur' , 'vehiculeImm' , 'villeDepX' , 'villeDepY' , 'villeArrX' , 'villeArrY', 'numTrajetType')
  END IF
END;
/

-- Si l'inscrit est le meme que conducteur et n'est pas blocke' on changer le traje

DECLARE

BEGIN
  IF NOT isBlocked('email') THEN
      UPDATE trajet SET .... WHERE conducteur = 'email' and numT= 'numTCible';
  END IF
END;
/

-- Laisser un avis, vérifie s'il est conducteur ou covoitueur
CREATE OR REPLACE PROCEDURE estConducteur
(var_email IN VARCHAR(200), var_num_trajet IN INTEGER)
RETURN BOOLEAN IS
var_resultat BOOLEAN = false;
email_conducteur IS
    SELECT conducteur FROM trajet, inscrit, participer
    WHERE trajet.numT = participer.numT AND  inscrit.email = trajet.conducteur
    AND trajet.numT = var_num_trajet
    AND participer.numCovoitureur = var_email;
BEGIN
    IF email_conducteur = var_email THEN
        var_resultat = true;
    END IF;
    RETURN var_resultat;
END;
/
