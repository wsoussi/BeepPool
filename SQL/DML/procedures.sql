DECLARE

BEGIN
  IF NOT isBlocked('email') THEN
      INSERT INTO trajet VALUES (prix, date_dep , date_ar , adr_rdv , adr_dep , nbPlace , conducteur , vehiculeImm , villeDepX , villeDepY , villeArrX , villeArrY , numTrajetType)
                                ('prix', 'date_dep' , 'date_ar' , 'adr_rdv' , 'adr_dep' , 'nbPlace' , 'conducteur' , 'vehiculeImm' , 'villeDepX' , 'villeDepY' , 'villeArrX' , 'villeArrY')
  END IF
END;
/
