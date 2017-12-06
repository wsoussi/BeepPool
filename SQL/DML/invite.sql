-- Chercher les trajets qui correspond aux villes de depart et d’arrivee et une date precis ou une date de marge -> mettre le marge (afficher les trajets qui ne sont pas complets)
SELECT *
FROM trajet, ville vd, ville va
WHERE trajet.villeDepX = vd.coordX AND
      trajet.villeDepY = vd.coordY AND
      trajet.villeArrX = va.coordX AND
      trajet.villeArrY = va.coordY AND
      vd.nomV = "Montpellier" AND
      va.nomV = "Marseille" AND
