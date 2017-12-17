conducteur-- verifier que seulement un admin peut ajouter un trajet type
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
DECLARE estLeConducteur TINYINT;
-- declarations pour la deuxieme partie
DECLARE leConducteur VARCHAR(200);
DECLARE placesOccup TINYINT;
DECLARE placesTot TINYINT;
SELECT count(*) INTO estLeConducteur FROM trajet WHERE NEW.numT = trajet.numT AND NEW.numCovoitureur = conducteur;
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
CREATE TRIGGER VERIF_PARTICIPER_NODRIVER_UPDATE BEFORE UPDATE ON participer
FOR EACH ROW
BEGIN
DECLARE estLeConducteur TINYINT;
-- declarations pour la deuxieme partie
DECLARE leConducteur VARCHAR(200);
DECLARE placesOccup TINYINT;
DECLARE placesTot TINYINT;
SELECT count(*) INTO estLeConducteur FROM trajet WHERE NEW.numT = trajet.numT AND NEW.numCovoitureur = conducteur;
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


-- verifier qu'à l'ajout d'un trajet le conducteur a une voiture et que la voiture qu'il a mit c'est à lui
-- et si il y a un trajet-type relatif alors l'ajouter
CREATE TRIGGER VERIF_TRAJET_INSERT BEFORE INSERT ON trajet
FOR EACH ROW
BEGIN
DECLARE conducteurNbVoitures TINYINT;
DECLARE voitureALui BOOLEAN;
IF (isBlocked(NEW.conducteur)) THEN
  SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'Operation interdite! Vous etes blocke`!';
END IF;
SELECT count(*) INTO conducteurNbVoitures FROM voiture WHERE NEW.conducteur = emailProprietaire;
SELECT count(*) INTO voitureALui FROM voiture WHERE NEW.conducteur = emailProprietaire AND NEW.vehiculeImm = immatriculation;
   IF (conducteurNbVoitures = 0) THEN
       SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Le conducteur n`a pas de voitures dans la base de donnees, donc il peut pas creer un trajet.';
   ELSEIF (NEW.date_dep < CAST(CURRENT_TIMESTAMP AS DATE) OR NEW.date_dep > DATE_ADD(CAST(CURRENT_TIMESTAMP AS DATE), INTERVAL 6 MONTH)) THEN
          SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Valeur invalide pour date_dep de trajet';
   ELSEIF (NEW.date_ar < NEW.date_dep) THEN
          SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Valeur invalide pour date_ar de trajet';
   ELSEIF (NEW.nbPlaceDispo <= 0 OR NEW.nbPlaceDispo >= (SELECT nbPlaces FROM voiture WHERE NEW.vehiculeImm = immatriculation)) THEN
          SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Valeur invalide pour nbPlaceDispo de trajet';
   ELSEIF (voitureALui = 0) THEN
       SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'La voiture n`est pas celle du conducteur donc le ntrajet n`est pas cree`';
   ELSEIF (trajetType(NEW.villeDepX, NEW.villeDepY, NEW.villeArrX, NEW.villeArrY) <> -1) THEN
         SET NEW.numTrajetType = trajetType(NEW.villeDepX, NEW.villeDepY, NEW.villeArrX, NEW.villeArrY);
   END IF;
END//
CREATE TRIGGER VERIF_TRAJET_UPDATE BEFORE UPDATE ON trajet
FOR EACH ROW
BEGIN
DECLARE conducteurNbVoitures TINYINT;
DECLARE voitureALui BOOLEAN;
IF (isBlocked(NEW.conducteur)) THEN
  SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'Operation interdite! Vous etes blocke`!';
END IF;
SELECT count(*) INTO conducteurNbVoitures FROM voiture WHERE NEW.conducteur = emailProprietaire;
SELECT count(*) INTO voitureALui FROM voiture WHERE NEW.conducteur = emailProprietaire AND NEW.vehiculeImm = immatriculation;
   IF (conducteurNbVoitures = 0) THEN
       SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Le conducteur n`a pas de voitures dans la base de donnees, donc il peut pas creer un trajet.';
   ELSEIF (NEW.date_dep < CAST(CURRENT_TIMESTAMP AS DATE) OR NEW.date_dep > DATE_ADD(CAST(CURRENT_TIMESTAMP AS DATE), INTERVAL 6 MONTH)) THEN
          SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Valeur invalide pour date_dep de trajet';
   ELSEIF (NEW.date_ar < NEW.date_dep) THEN
          SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Valeur invalide pour date_ar de trajet';
   ELSEIF (NEW.nbPlaceDispo <= 0 OR NEW.nbPlaceDispo >= (SELECT nbPlaces FROM voiture WHERE NEW.vehiculeImm = immatriculation)) THEN
          SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Valeur invalide pour nbPlaceDispo de trajet';
   ELSEIF (voitureALui = 0) THEN
       SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'La voiture n`est pas celle du conducteur donc le ntrajet n`est pas cree`';
   ELSEIF (trajetType(NEW.villeDepX, NEW.villeDepY, NEW.villeArrX, NEW.villeArrY) <> -1) THEN
         SET NEW.numTrajetType = trajetType(NEW.villeDepX, NEW.villeDepY, NEW.villeArrX, NEW.villeArrY);
   END IF;
END//
