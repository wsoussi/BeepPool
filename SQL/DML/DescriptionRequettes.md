#**LES REQUÊTES À FAIRE**

##LES REQUETTES POUR L'INVITÉ
- Chercher les trajets qui correspondent aux villes de départ et d'arrivée et une date précise ou un interval -> mettre l'interval (afficher les trajets qui ne sont pas complets)
- s'inscrire sur le site et devenir membre (il ne peut pas s'ajouter comme admin)

##LES REQUÊTES POUR L'ADMIN
- Créer des villes pour qu'elles soient utilisées par les trajets
- Créer des trajets types

##LES REQUÊTES POUR L'ABONN2
- Proposer un trajet (avec possibilité de le lier à un trajet type) et ajouter les informations qui manquent en cas de creation de trajets complementaires ( creer par les villes etapes) (ne pas oublier les contraintes sur le prix avec une vue sur trajet)
- changer
- Participer a un trajet
- Donner un avis sur un covoitureur pour un trajet specifique (faisant distinction sur le cas où le donneur d'avis est un passagers ou bien le conducteur)

##TRIGGERS D'ENVIRONNEMENT
- Calculer la distance entre deux ville a chaque creation de trajet ou trajet type. FORMULE:
<br> DISTANCE (A,B) = R * arccos(sin(latA) * sin(latB) + cos(latA) * cos(latB) * cos(lonA-lonB))
<br>PS: R = 6372,795477598 Km (rayon quadratique moyen de la terre)
