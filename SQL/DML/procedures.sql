-- Si l'inscrit n'est pas blocke' on ajoute le trajet
CREATE OR REPLACE PROCEDURE isBlocked
(var_email IN VARCHAR(320))
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
