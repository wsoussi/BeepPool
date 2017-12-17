-- Exemple de création de villes
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
-- wissem rend jeremie un admin
CALL Promotion_Membre('wissem.soussi@etu.umontpellier.fr','wissem','jeremie.daughter@montp.fr');
-- Blockage/Deblockage d'un inscrit avec une date de fin blockage
CALL Blockage_Membre('wissem.soussi@etu.umontpellier.fr','wissem', 'lazar.angelov@dope.fr', '2018-02-18');
