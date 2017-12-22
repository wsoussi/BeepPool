-- Exemple de création de ville
INSERT INTO ville(coordX,coordY,nom,pays,region)
VALUES (3.8772300,43.6109200, 'Montpellier', 'France', 'Occitanie');

INSERT INTO ville(coordX,coordY,nom,pays,region)
VALUES (5.3810700,43.2969500, 'Marseille', 'France', 'Provence-Alpes-Côte d`Azur');

INSERT INTO ville(coordX,coordY,nom,pays,region)
VALUES (2.352222,43.2969500, 'Paris', 'France', 'Ile de France');

INSERT INTO ville(coordX,coordY,nom,pays,region)
VALUES (7.017369,43.552847, 'Cannes', 'France', 'Provence-Alpes-Côte d`Azur');

-- creer un admin Wissem
insert into inscrit (email, nom, prenom, dateNaiss, numTel, mdp,estAdmin)
VALUES
('wissem.soussi@etu.umontpellier.fr', 'Soussi', 'Wissem', '1996-01-16', '0033634897610', 'wissem', true);

--creer des membres non admin
insert into inscrit (email, nom, prenom, dateNaiss, numTel, mdp)
VALUES
('lazar.angelov@dope.fr', 'Lazar', 'Angelov', '1996-01-16', '0033634897610', 'lazar');

insert into inscrit (email, nom, prenom, dateNaiss, numTel, mdp)
VALUES
('jeremie.daughter@montp.fr', 'daughter', 'Jeremie', '1997-01-01', '003321349078', 'jeremie');


-- REQUETTES ADMIN
-- wissem rend jeremie  admin
CALL Promotion_Membre('wissem.soussi@etu.umontpellier.fr','wissem','jeremie.daughter@montp.fr');
-- Blocage/Deblocage d'un inscrit avec une date de fin blocage
CALL Blockage_Membre('wissem.soussi@etu.umontpellier.fr','wissem', 'lazar.angelov@dope.fr', '2018-02-18');

-- AJOUT VOITURE
insert into voiture (immatriculation, marque, modele, annee, couleur, nbPlaces, emailProprietaire)
values ('wiz96','Tesla', 'Roadster', 2017, 'rouge', 4, 'wissem.soussi@etu.umontpellier.fr');

--creer trajet
insert into trajet
  (prix, date_dep, adr_rdv, adr_ar, conducteur, vehiculeImm, nbPlaceDispo, villeDepX, villeDepY, villeArrX, villeArrY)
  VALUES
  (1, '2017-12-23', 'fac des sciences', 'theatre de Cannes', 'wissem.soussi@etu.umontpellier.fr', 'wiz96', 3, 3.877230, 43.610920, 7.017369, 43.552847);

  insert into trajet
    (prix, date_dep, date_ar, adr_rdv, adr_ar, conducteur, vehiculeImm, nbPlaceDispo, villeDepX, villeDepY, villeArrX, villeArrY)
    VALUES
    (20, '2017-12-19', '2017-12-19', 'fac des sciences', 'theatre de Cannes', 'wissem.soussi@etu.umontpellier.fr', 'wiz96', 3, 3.877230, 43.610920, 7.017369, 43.552847);

--participation au trajet
insert into participer
  (numT, numCovoitureur)
  values
  (3,'lazar.angelov@dope.fr');

--donner un avis
insert into avis
  (numT,numDonneur,numReceveur,nbEtoile,commentaire)
  VALUES
  (3,'jeremie.daughter@montp.fr','lazar.angelov@dope.fr',5,'Sympa');
