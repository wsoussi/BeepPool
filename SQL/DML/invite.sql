/*
fichier createTablesMYSQL.sql
Numero 21509841, Dautheribes, Jérémie
Numero 21505680, Soussi, Wissem
*/

-- Chercher les trajets qui correspondent aux villes de depart et d’arrivee et une date precise ou une date approximative -> mettre la marge (afficher les trajets qui ne sont pas complets)
SELECT inscrit.nom, vd.nom, va.nom, trajet.date_dep, trajet.date_ar, trajet.prix, calcul_distance(trajet.villeDepX, trajet.villeDepY, trajet.villeArrX, trajet.villeArrY)
FROM trajet, inscrit, ville vd, ville va
WHERE trajet.conducteur = inscrit.email AND
      trajet.villeDepX = vd.coordX AND
      trajet.villeDepY = vd.coordY AND
      trajet.villeArrX = va.coordX AND
      trajet.villeArrY = va.coordY
      AND date_dep > curdate()
      AND villeDepX = "value" AND villeDepY = "value"
      AND villeArrX = "value" AND villeArrY = "value"
      AND date_dep < DATE_ADD( "value", INTERVAL 5 DAY) AND date_dep >= (maxDate (DATE_SUB("velue", INTERVAL 5 DAY),curdate()))
      AND trajet.nbPlaceDispo > (SELECT count(*)
                                  FROM participer
                                  WHERE participer.numT = trajet.numT)
ORDER BY date_dep ASC;

-- S'inscrire sur le site et devenir membre
INSERT INTO inscrit
(email, nom, prenom, dateNaiss, adresse, codeP, pays, numTel, mdp)
VALUES
('nom.prenom@serveur.com', 'nom', 'prenom', 'jj-mm-aaaa', 'adresse', 'codeP', 'pays', 'numTel', 'mdp');
