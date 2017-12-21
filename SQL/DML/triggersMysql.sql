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
DECLARE trajetExiste TINYINT DEFAULT 0;
DECLARE leConducteur VARCHAR(200);
SELECT count(*) INTO estLeConducteur FROM trajet WHERE NEW.numT = trajet.numT AND NEW.numCovoitureur = conducteur;
   IF (estLeConducteur = 1) THEN
       SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Vous etes le conducteur de ce trajet donc vous participez dejà par default.';
   END IF;
-- verifier qu'un membre ne peut pas s'inscrire s'il est blocke' ou l'autre est blocke' ou il y a pas de place ou numTrajet n'existe pas
   SELECT conducteur INTO leConducteur FROM trajet WHERE trajet.numT = NEW.numT;
    SELECT count(*) INTO trajetExiste FROM trajet WHERE trajet.numT = NEW.numT;
      IF (isBlocked(NEW.numCovoitureur)) THEN
          SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'Vous etes blocke`, donc vous ne pouvez participer à aucun trajet.';
      ELSEIF (trajetExiste = 0) THEN
          SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'Le trajet reference` n`est pas trouve`.';
      ELSEIF (isBlocked(leConducteur)) THEN
          SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'Le conducteur de ce trajet est blocke`, sont trajet n`est plus valable.';
      ELSEIF (NEW.iVD < NEW.iVM AND NEW.iVD <> NULL AND NEW.iVM <> NULL) THEN
          SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'La ville de descente que vous avez choisi viens avant la ville ou vous allez monter.';
      ELSEIF (estPlein(NEW.numT, NEW.iVM, NEW.iVD)) THEN
          SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'Il y a pas de place dans ce trajet pour les villes de monte et de descente choisi.';
      END IF;
END//

CREATE TRIGGER VERIF_PARTICIPER_NODRIVER_UPDATE BEFORE UPDATE ON participer
FOR EACH ROW
BEGIN
DECLARE estLeConducteur TINYINT;
-- declarations pour la deuxieme partie
DECLARE trajetExiste TINYINT DEFAULT 0;
DECLARE leConducteur VARCHAR(200);
SELECT count(*) INTO estLeConducteur FROM trajet WHERE NEW.numT = trajet.numT AND NEW.numCovoitureur = conducteur;
   IF (estLeConducteur = 1) THEN
       SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Vous etes le conducteur de ce trajet donc vous participez dejà par default.';
   END IF;
-- verifier qu'un membre ne peut pas s'inscrire s'il est blocke' ou l'autre est blocke' ou il y a pas de place ou numTrajet n'existe pas
   SELECT conducteur INTO leConducteur FROM trajet WHERE trajet.numT = NEW.numT;
    SELECT count(*) INTO trajetExiste FROM trajet WHERE trajet.numT = NEW.numT;
      IF (isBlocked(NEW.numCovoitureur)) THEN
          SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'Vous etes blocke`, donc vous ne pouvez participer à aucun trajet.';
      ELSEIF (trajetExiste = 0) THEN
          SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'Le trajet reference` n`est pas trouve`.';
      ELSEIF (isBlocked(leConducteur)) THEN
          SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'Le conducteur de ce trajet est blocke`, sont trajet n`est plus valable.';
      ELSEIF (NEW.iVD < NEW.iVM AND NEW.iVD <> NULL AND NEW.iVM <> NULL) THEN
          SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'La ville de descente que vous avez choisi viens avant la ville ou vous allez monter.';
      ELSEIF (estPlein(NEW.numT, NEW.iVM, NEW.iVD)) THEN
          SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'Il y a pas de place dans ce trajet pour les villes de monte et de descente choisi.';
      END IF;
END//


-- verifier qu'à l'ajout d'un trajet le conducteur a une voiture et que la voiture qu'il a mit c'est à lui
-- et si il y a un trajet-type relatif alors l'ajouter, vérifie aussi le prix par km
CREATE TRIGGER VERIF_TRAJET_INSERT BEFORE INSERT ON trajet
FOR EACH ROW
BEGIN
DECLARE conducteurNbVoitures TINYINT;
DECLARE voitureALui BOOLEAN;
DECLARE distance DECIMAL(6,2);
DECLARE trajet_Type INTEGER;
DECLARE prix_TT DECIMAL(6,2);
SET trajet_Type = trajetType(NEW.villeDepX, NEW.villeDepY, NEW.villeArrX, NEW.villeArrY);
CALL calcul_distance(NEW.villeDepX, NEW.villeDepY, NEW.villeArrX, NEW.villeArrY,distance);
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
        ELSE
            SET NEW.numTrajetType = trajet_Type;
        END IF;
   ELSEIF (trajet_Type = -1) THEN
        IF (calcul_prix_par_km(distance,NEW.prix) > 0.10 ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Prix par km trop élevé, le prix par km doit être <= à 0.10€.';
        END IF;
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
SET trajet_Type = trajetType(NEW.villeDepX, NEW.villeDepY, NEW.villeArrX, NEW.villeArrY);
CALL calcul_distance(NEW.villeDepX, NEW.villeDepY, NEW.villeArrX, NEW.villeArrY,distance);
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
        ELSE
            SET NEW.numTrajetType = trajet_Type;
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
DECLARE estConducteur TINYINT(1) UNSIGNED;
DECLARE numConducteur VARCHAR(200);
DECLARE estCovoitureurD TINYINT(1) UNSIGNED;
DECLARE estCovoitureurR TINYINT(1) UNSIGNED;
DECLARE dateTrajet DATE;

SET estConducteur = estConducteur(NEW.numDonneur, NEW.numT);
SET estCovoitureurD = estCovoitureur(NEW.numDonneur, NEW.numT);
SET estCovoitureurR = estCovoitureur(NEW.numReceveur, NEW.numT);
SELECT conducteur INTO numConducteur FROM trajet WHERE trajet.numT = NEW.numT;
SELECT date_ar INTO dateTrajet FROM trajet WHERE trajet.numT = NEW.numT;

IF (dateTrajet > CURDATE()) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vous pouvez donner un avis seulement apres que le trajet est conclu';
ELSEIF (NEW.numDonneur = NEW.numReceveur) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vous ne pouvez pas vous donner un avis à vous même';
ELSEIF (estCovoitureurD AND numConducteur <> NEW.numReceveur) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vous êtes covoitureur, vous ne pouvez donner un avis qu\'au conducteur';
ELSEIF (estConducteur = true AND estCovoitureurR = false) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vous êtes le conducteur, vous pouvez donner un avis seulement aux covoitureurs du trajet selectionne`';
END IF;
END//

CREATE TRIGGER VERIF_AVIS_UPDATE BEFORE UPDATE ON avis
FOR EACH ROW
BEGIN
DECLARE estConducteur TINYINT(1) UNSIGNED;
DECLARE numConducteur VARCHAR(200);
DECLARE estCovoitureurD TINYINT(1) UNSIGNED;
DECLARE estCovoitureurR TINYINT(1) UNSIGNED;
DECLARE dateTrajet DATE;

SET estConducteur = estConducteur(NEW.numDonneur, NEW.numT);
SET estCovoitureurD = estCovoitureur(NEW.numDonneur, NEW.numT);
SET estCovoitureurR = estCovoitureur(NEW.numReceveur, NEW.numT);
SELECT conducteur INTO numConducteur FROM trajet WHERE trajet.numT = NEW.numT;
SELECT date_ar INTO dateTrajet FROM trajet WHERE trajet.numT = NEW.numT;

IF (dateTrajet > CURDATE()) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vous pouvez donner un avis seulement apres que le trajet est conclu';
ELSEIF (NEW.numDonneur = NEW.numReceveur) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vous ne pouvez pas vous donner un avis à vous même';
ELSEIF (estCovoitureurD AND numConducteur <> NEW.numReceveur) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vous êtes covoitureur, vous ne pouvez donner un avis qu\'au conducteur';
ELSEIF (estConducteur = true AND estCovoitureurR = false) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Vous êtes le conducteur, pouvez donner un avis seulement aux covoitureurs du trajet selectionne`';
END IF;
END//
