-- Chercher les trajets qui correspond aux villes de depart et d’arrivee et une date precis ou une date de marge -> mettre le marge (afficher les trajets qui ne sont pas complets)
SELECT inscrit.nom, vd.nomV, va.nomV, trajet.date_dep, trajet.date_ar
FROM trajet, ville vd, ville va, inscrit
WHERE trajet.conducteur = inscrit.email AND
      trajet.villeDepX = vd.coordX AND
      trajet.villeDepY = vd.coordY AND
      trajet.villeArrX = va.coordX AND
      trajet.villeArrY = va.coordY AND
      vd.nomV = "Montpellier" AND
      vd.codePostale = "codePMont" AND
      va.nomV = "Marseille" AND
      va.codePoste = "codePMarse" AND
      date_dep >= "date"-"toleranceEnJours" AND
      date_dep <= "date"+"toleranceEnJours" AND
      nbPlace > (SELECT count(*)
                 FROM parteciper
                 WHERE parteciper.numT = trajet.numT
                )
      ;

-- S'inscrir sur le site et devenir membre
INSERT INTO inscrit
(email, nom, prenom, dateNaiss, adresse, codeP, pays, numTel, mdp)
VALUES
("nom.prenom@serveur.com", "nom", "prenom", "jj-mm-aaaa", "adresse", "codeP", "pays", "numTel", "mdp"); --- il met pas lui estAdmin
