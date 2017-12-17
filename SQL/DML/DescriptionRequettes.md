**LES REQUÊTES À FAIRE**

##LES REQUÊTES POUR L'INVITÉ
+ Chercher les trajets qui correspondent aux villes de départ et d'arrivée et une date précise ou un interval -> mettre l'interval (afficher les trajets qui ne sont pas complets)
+ s'inscrire sur le site et devenir membre (il ne peut pas s'ajouter comme admin)

##LES REQUÊTES POUR L'ADMIN
+ Créer des trajets types (trigger: seulement les admin peuvent le faire)
+ Fermer temporairement ou définitivement un compte
+ Créer des villes pour qu'elles soient utilisées par les trajets

##LES REQUÊTES POUR L'ABONNÉ
- Proposer un trajet (s'il est pas blocke')(trigger: possibilité de le lier à un trajet type) (trigger contraintes sur le prix avec une vue sur trajet)
- changer un trajet (s'il est pas blocke')
+ Participer a un trajet (trigger: ne pas parteciper s'il est blocke' ou si il n'y a plus de place)(trigger: le conducteur ne peut pas parteciper au trajet de lui meme)
- Donner un avis sur un covoitureur pour un trajet specifique (faisant distinction sur le cas où le donneur d'avis est un passagers ou bien le conducteur)

##TRIGGERS ET PROCEDURES D'ENVIRONNEMENT
+ Calculer la distance entre deux ville a chaque creation de trajet ou trajet type. FORMULE:
<br> DISTANCE (A,B) = R * arccos(sin(latA) * sin(latB) + cos(latA) * cos(latB) * cos(lonA-lonB))
<br>PS: R = 6372,795477598 Km (rayon quadratique moyen de la terre)
+ On fixe X = longitude et Y = latitude
- Donner un avis sur un covoitureur pour un trajet specifique (faisant distinction sur le cas où le donneur d'avis est un passagers ou bien le conducteur)
+ verifier que nbPlace de trajet soit < nbplace de la voiture

##POUR JEREMIE LE MATIN
Tu fait jusqu'ou tu arrive à faire :)
- La procedure que tu a ecrit sur savoir si un trajet fait parti d'un trajet type marche! Maintenant faudra faire un trigger presque identique qui se declanche à l'ajout d'un trajet et qui rempli l'attribut numTrajetType automatiquement si le trajetType existe.
- A chaque ajout de trajet si celui-ci a un trajet-type verifier qu'il depasse pas prixParKm sinon verifier que ça depasse pas 0.10€ par km.
- Tu a ecrit la procedure qui verifie si un inscrit il est le conducteur tu trajet et elle marche.
Maintenant faut faire un trigger que à l'ajout d'un avis (INSERT) il verifie si celui qui a donne' l'avis est conducteur:
si OUI alors il peut pas donner l'avis,
si NON alors on verifie si il a partecipe' au trajet et si OUI il pourra evaluer le conducteur;
- Un trigger sur INSERT trajet qui verifie que le conducteur aille bien une voiture (et si la voiture qu'il a mit elle est bien à lui et pas de quelqu'un d'autre).
