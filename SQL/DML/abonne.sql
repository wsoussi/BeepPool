-- proposer un trajet


-- participer à un trajet
INSERT INTO PARTECIPER(numT, emailCovoitureur)
VALUES (001, "zobi@covoitueur.fr");

-- donner un avis
INSERT INTO AVIS(numT, numDonneur, numReceveur, nbEtoile, commentaire)
VALUES (001, 333, 555, 3, "moyen/20");

-- trigger sur l'avis
CREATE TRIGGER ctrl_avis
BEFORE INSERT ON avis
DECLARE
resultat avis.numT%TYPE;
BEGIN
  SELECT 
