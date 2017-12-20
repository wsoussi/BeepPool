<h1>RAPPORT DU PROJET BDD L3 2017</H1>

<h2>Wissem Soussi et Jérémie Daughtauribe</h2>
<h2>Decembre 2017</h2>

<h4>MODÈLE ENTITÉ ASSOCIATION</h3>

<img src="./modeleEA.png">

<h4>MODÈLE RELATIONNEL DE LA BDD</h3>

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
( <u>_numT_</u> , <u>_coordX_</u> , <u>_coordY_</u> , nbPerRec , nbPerDes )

**PARTECIPER**
( <u>_numT_</u> , <u>_emailCovoitureur_</u> )


**AVIS**
( <u>_numT_</u> , <u>_numDonneur_</u> , <u>_numRéceveur_</u>, nbEtoile, commentaire )
