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
-- et si il y a un trajet-type relatif alors l'ajouter, vérifie aussi le prix par km
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
DECLARE distance DECIMAL(6,2) = calcul_distance(NEW.villeDepX, NEW.villeDepY, NEW.arrX, NEW.arrY);
DECLARE trajet_Type INTEGER = trajetType(NEW.villeDepX, NEW.villeDepY, NEW.villeArrX, NEW.villeArrY);
DECLARE prix_TT DECIMAL(6,2);
IF (isBlocked(NEW.conducteur)) THEN
  SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'Operation interdite! Vous etes blocke`!';
END IF;

SELECT count(*) INTO conducteurNbVoitures FROM voiture WHERE NEW.conducteur = emailProprietaire;
SELECT count(*) INTO voitureALui FROM voiture WHERE NEW.conducteur = emailProprietaire AND NEW.vehiculeImm = immatriculation;

IF (trajet_Type <> -1) THEN
    SELECT prixParKm INTO prix_TT FROM trajet_type
    WHERE trajet_type.villeDepX = NEW.villeDepX AND trajet_type.villeDepY = NEW.villeDepY
    AND trajet_type.villeArrX = NEW.villeArrX AND trajet_type.villeArrY = NEW.villeArrY;
END IF;

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
   ELSEIF (trajet_Type <> -1) THEN
         IF (calcul_prix_par_km(distance,NEW.prix) > prix_TT) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Prix trop élevé.';
        ELSEIF
            SET NEW.numTrajetType = trajetType(NEW.villeDepX, NEW.villeDepY, NEW.villeArrX, NEW.villeArrY);
        END IF;
   ELSEIF (trajet_Type = -1) THEN
        IF (calcul_prix_par_km(distance,NEW.prix) > 0.10 )
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Prix par km trop élevé, le prix par km doit être <= à 0.10€.';
        END IF;
   END IF;
END//


-- triggers sur l'ajout des avis --

CREATE TRIGGER VERIF_AVIS_INSERT BEFORE INSERT ON avis
FOR EACH ROW
BEGIN
DECLARE estConducteur TINYINT(1) UNSIGNED = estConducteur(NEW.numDonneur, NEW.numT);
DECLARE numConducteur INTEGER;

IF (conducteur = true) THEN
    SELECT numT INTO numConducteur FROM trajet, avis
    WHERE trajet.numT = NEW.numT;
END IF;

IF (NEW.numDonneur = NEW.numReceveur) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vous ne pouvez pas vous donner un avis à vous même';
ELSEIF (estConducteur = false AND numReceveur <>  numConducteur) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vous êtes covoitureur, vous ne pouvez donner un avis qu\'au conducteur';
END IF;
END//


CREATE TRIGGER VERIF_AVIS_UPDATE BEFORE UPDATE ON avis
FOR EACH ROW
BEGIN
DECLARE estConducteur TINYINT(1) UNSIGNED = estConducteur(NEW.numDonneur, NEW.numT);
DECLARE numConducteur INTEGER;

IF (conducteur = true) THEN
    SELECT numT INTO numConducteur FROM trajet, avis
    WHERE trajet.numT = NEW.numT;
END IF;

IF (NEW.numDonneur = NEW.numReceveur) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vous ne pouvez pas vous donner un avis à vous même';
ELSEIF (estConducteur = false AND numReceveur <>  numConducteur) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vous êtes covoitureur, vous ne pouvez donner un avis qu\'au conducteur';
END IF;
END//
