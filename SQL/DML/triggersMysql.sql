-- verifier que seulement un admin peut ajouter un trajet type
CREATE TRIGGER VERIF_TRAJET_TYPE_INSERT BEFORE INSERT ON trajet_type
FOR EACH ROW
BEGIN
DECLARE Admin BOOLEAN;
SELECT count(*) INTO Admin FROM inscrit WHERE NEW.email_admin = email AND estAdmin = true;
   IF (Admin=false) THEN
       SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Il faut etre admin pour modifier les trajets type.';
   END IF;
END//

CREATE TRIGGER VERIF_TRAJET_TYPE_UPDATE BEFORE UPDATE ON trajet_type
FOR EACH ROW
BEGIN
DECLARE Admin BOOLEAN;
SELECT count(*) INTO Admin FROM inscrit WHERE NEW.email_admin = email AND estAdmin = true;
   IF (Admin=false) THEN
       SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Il faut etre admin pour modifier les trajets type.';
   END IF;
END//


-- verifier que le conducteur ne s'inscrit pas sur son propre trajet comme passage're
CREATE TRIGGER VERIF_PARTICIPER_NODRIVER BEFORE INSERT ON participer
FOR EACH ROW
BEGIN
DECLARE estLeConducteur BOOLEAN;
-- declarations pour la deuxieme partie
DECLARE leConducteur VARCHAR(200);
DECLARE placesOccup TINYINT;
DECLARE placesTot TINYINT;
SELECT count(*) INTO estLeConducteur FROM participer,trajet WHERE participer.numT = trajet.numT AND NEW.numCovoitureur = participer.numCovoitureur;
   IF (estLeConducteur = 1) THEN
       SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Vous etes le conducteur de ce trajet donc vous participez dejà par default.';
   END IF;
-- verifier qu'un membre ne peut pas s'inscrire s'il est blocke' ou l'autre est blocke' ou il y a pas de place
   SELECT conducteur INTO leConducteur FROM trajet WHERE trajet.numT = NEW.numT;
   SELECT nbPlaceDispo INTO placesTot FROM trajet WHERE trajet.numT = NEW.numT;
   SELECT count(*) INTO placesOccup FROM participer WHERE participer.numT = NEW.numT;
      IF (isBlocked(NEW.numCovoitureur)) THEN
          SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'Vous etes blocke`, donc vous ne pouvez participer à aucun trajet.';
      ELSEIF (isBlocked(leConducteur)) THEN
          SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'Le conducteur de ce trajet est blocke`, sont trajet n`est plus valable.';
      ELSEIF (placesTot - placesOccup = 0) THEN
          SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'Le trajet est complet.';
      END IF;
END//
