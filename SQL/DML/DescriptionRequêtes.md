**LES REQUÊTES À FAIRE**

##LES REQUÊTES POUR L'INVITÉ
+ Chercher les trajets qui correspondent aux villes de départ et d'arrivée et une date précise ou un intervalle -> mettre l'intervalle (afficher les trajets qui ne sont pas complets)
+ s'inscrire sur le site et devenir membre (il ne peut pas s'ajouter comme admin)

##LES REQUÊTES POUR L'ADMIN
+ Créer des trajets types (trigger: seulement les admin peuvent le faire)
+ Fermer temporairement ou définitivement un compte
+ Créer des villes pour qu'elles soient utilisées par les trajets

##LES REQUÊTES POUR L'ABONNÉ
+ Proposer un trajet (s'il est pas bloqué et si le conducteur aussi il est pas bloqué)(trigger: possibilité de le lier à un trajet type) (trigger contraintes sur le prix avec une vue sur trajet)
+ changer un trajet (s'il est pas bloqué et si le conducteur aussi il est pas bloqué)(trigger: possibilité de le lier à un trajet type)
+ Participer a un trajet (trigger: ne pas participer s'il est bloqué ou si il n'y a plus de place)(trigger: le conducteur ne peut pas participer au trajet de lui même)
- Donner un avis sur un covoitureur pour un trajet specifique (faisant distinction sur le cas où le donneur d'avis est un passagers ou bien le conducteur)

##TRIGGERS ET PROCEDURES D'ENVIRONNEMENT
+ Calculer la distance entre deux ville a chaque creation de trajet ou trajet type. FORMULE:
<br> DISTANCE (A,B) = R * arccos(sin(latA) * sin(latB) + cos(latA) * cos(latB) * cos(lonA-lonB))
<br>PS: R = 6372,795477598 Km (rayon quadratique moyen de la terre)
+ On fixe X = longitude et Y = latitude
- Donner un avis sur un covoitureur pour un trajet specifique (faisant distinction sur le cas où le donneur d'avis est un passagers ou bien le conducteur)
+ verifier que nbPlace de trajet soit < nbplace de la voiture
