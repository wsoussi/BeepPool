#**LES REQUETES À FAIRE**

##LES REQUETES POUR L'INVITE'
- Chercher les trajets qui correspond aux villes de depart et d'arrivee et une date precis ou une date de marge -> mettre le marge (afficher les trajets qui ne sont pas complets)
- s'inscrir sur le site et devenir membre (il ne peut pas s'ajouter comme admin)

##LES REQUETES POUR L'ADMIN
- Creer des villes pour qu'ils soient utilisees par les trajets
- Creer des trajets types

##LES REQUETTES POUR L'ABONNE
- Proposer un trajet (avec possibilite' de le lier a un trajet type) et ajouter les informations qui manques en cas de creation de trajets complementaires ( creer par les villes etapes) (ne pas oublier les contraintes sur le prix avec une vue sur trajet)
- changer
- Parteciper a un trajet
- Donner un avis sur un covoitureur pour un trajet specifique (faisant distinction sur le cas où le donneur d'avis est un passagers ou bien le conducteur)

##TRIGGERS D'ENVIRONNEMENT
- Calculer la distance entre deux ville a chaque creation de trajet ou trajet type. FORMULE:
<br> DISTANCE (A,B) = R * arccos(sin(latA) * sin(latB) + cos(latA) * cos(latB) * cos(lonA-lonB))
<br>PS: R = 6372,795477598 Km (rayon quadratique moyen de la terre)
