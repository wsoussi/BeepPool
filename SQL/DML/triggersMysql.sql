-- Vérifie si l' inscrit est bloqué ou pas
CREATE TRIGGER VERIF_VALUES_MEMBRE BEFORE INSERT ON membre
FOR EACH ROW
BEGIN
   IF (NEW.rating > 5 OR NEW.rating < 0) THEN
       SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Invalid value for rating. Must be between 0 and 5';

   ELSEIF (NEW.estAdmin NOT IN ('ADM','NONADM')) THEN
       SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Invalid value for estAdmin. Must be ADM or NONADM';

   ELSEIF (NEW.estActif NOT IN ('ACT','NONACT')) THEN
       SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Invalid value for estActif. Must be ACT or NONACT';
   END IF;
END;//
