<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

<CENTER>
<h1>RAPPORT DU PROJET BDD L3 2017</H1>
<h2>Wissem Soussi et Jérémie Daughtauribe</h2>
<h2>Décembre 2017</h2>
</CENTER>

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>


<h4>1) MODÈLE ENTITÉ ASSOCIATION</h4>
<br>
<br>
<img src="./modeleEA.png">
<br>
<br>
<br>
<br>

<h4>2) MODÈLE RELATIONNEL</h4>
<br>
<br>

**INSCRIT**
(<u>email</u> , nom , prenom , dateNaiss , adresse , codePostale , pays , numTel , mdp , estAdmin , dateFinBlockage )

**VOITURE** (<u>immatriculation</u> , marque , modele , annee , couleur , nbPlaces , _emailProprietaire_ )

**VILLE**
(<u>coordX</u> , <u>coordY</u> , nomV , pays , region )

**TRAJET_TYPE**
( <u>numTT</u> , prixParKm , _villeDepX_ ,  _villeDepY_ , _villeArrX_ , _villeArrY_ , _emailAdmin_ )

**TRAJET**
( <u>numT</u> , prix , date_dep , date_ar , adr_rdv , adr_ar , nbPlacesDispo , _conducteur_ , _vehiculeImm_ ,  _villeDepX_ ,  _villeDepY_ , _villeArrX_ , _villeArrY_ , _numTrajetType_ )

**ETAPES**
( <u>_numT_</u> , <u>_coordX_</u> , <u>_coordY_</u> , ordre )

**PARTECIPER**
( <u>_numT_</u> , <u>_emailCovoitureur_</u> , iVM , iVD )


**AVIS**
( <u>_numT_</u> , <u>_numDonneur_</u> , <u>_numRéceveur_</u>, nbEtoile, commentaire )
<br>
<br>
<br>
<br>
<br>
<br>

<h4> 3) ECLAIREMENT DE LA CONCEPTION</h4>
<br>

Un internaute qui rentre dans le site sans s'identifier peut (fichier “invite.sql”) rechercher des trajets en insérant la ville de départ, la ville d'arrivée, une date et une “tolérance” de jours: si par exemple la date est le 10/01/2018 et la tolérance est de 5 jours les trajets affichés seront ceux du 05/01/2018 jusqu’à 15/01/2018.
Si la borne inférieure de cet interval est inférieur à la date courante alors la borne inférieure va être changée par la date courante.
Les trajets vont être affichés par ordre croissant des dates de départ et ceux qui n’ont plus de places disponibles ne seront pas pris en compte.
Pour chaque trajet on affichera d’une façon supplémentaire les dates de départ et d'arrivée, la distance en kilomètres, le prix et le nom du conducteur (sans autres informations sur ce dernier).
Pour avoir plus d’information sur le conducteur d’un trajet et pour participer à ce dernier il faudra s’ inscrir (fichier “invite.sql”) et devenir membre du site.
Le membre sera identifié par un email, et il devra émettre obligatoirement son nom, prénom, date de naissance, numéro de téléphone et un mot de pass (fichier “createTablesMYSQL.sql” -> `TABLE inscrit`).
Le ranking des membres est entre 0 et 5 (l'évaluation classique par nombre d'étoiles) et il n’y a pas de limite d’age, par contre la date de naissance ne doit pas bien-sûr être supérieur à la date courante et l’age maximale est de 120 ans (fichier “createTablesMYSQL.sql” -> `TRIGGER VERIF_INSCRIT`).

**PS**: chaque trigger dans la base de données est dupliqué en trigger `before insert` et trigger `before update` puisque MYSQL ne permet pas de faire ` insert OR update` .





Un membre peut être élu comme admin par un autre admin, donc on considère qu’au début il y aura un membre mis comme admin par l’administrateur de la base de données  (fichier “admin.sql” -> `PROCEDURE Promotion_Membre`).


Un admin peut aussi bloquer un membre en définissant une date ou le blocage aura fin. De la même façon, il pourra débloquer un membre en définissant une date de fin blocage antécédent à la date courante  (fichier “admin.sql” -> `PROCEDURE Blockage_Membre`).

Un admin peut aussi enregistrer dans la base de données des villes (fichier “admin.sql”) en mettant leurs nom, pays et region relatifs et identifiées par les coordonnées GPS (longitude et latitude) (fichier “createTablesMYSQL.sql” -> `TABLE ville`).

En fin l’admin peut créer des trajets types identifiée par une ville de départ, une ville de retour, et avec un prix par kilomètre maximale (fichier “createTablesMYSQL.sql” -> `TABLE trajet_type`). Le trajet type reference apres l’admin qui l’a créé (fichier “triggersMysql.sql” -> `TRIGGER VERIF_TRAJET_TYPE_INSERT`).

Un membre peut enregistrer dans la base de données une voiture qu’il utilise pour le covoiturage; la voiture sera identifiée par l’immatriculation, et devra obligatoirement avoir une marque, un modèle, un nombre de places et l’email du propriétaire qui doit être un membre du site (fichier “createTablesMYSQL.sql” -> `TABLE voiture`).
La date d’immatriculation, si spécifiée, doit être inférieur à la date d’aujourd’hui et supérieur au 1883 (premières voitures commercialisées) et le nombre de places se situe entre 0 et 9 (si superieur de 9 on parle de mini-bus et ne plus de voitures) (fichier “createTablesMYSQL.sql” -> `TRIGGER VERIF_VOITURE`).

<br>
<br>
Un membre propose un trajet ....(table trajet)
conditions trajets....(trigger trajet et procedures(fonctions) liees )
<br>
<br>
Un membre participe à un trajet ....(table participer)
conditions participer....(trigger participer et procedures(fonctions) liees )
<br>
<br>
Un membre peut donner un avis ....(table avis)
conditions avis....(trigger avis et procedures(fonctions) liees )
<br>
<br>
Un membre peut faire la recherche comme l'invite' mais il voit tous les infos sur le conducteur

<h4>EXEMPLE DE CODE SQL DANS MARKDOWN ;)</h4>
<br>
```sql
insert into voiture (immatriculation, marque, modele, annee, couleur, nbPlaces, emailProprietaire)
values ("value", "value", "value", "value", "value", "value", "value");
```