# MODÈLE RELATIONEL DE LA BDD#
**INSCRIT**
(<u>email</u> , nom , prenom , age , adresse , numTel , mdp, estAdmin )

**VOITURE** (<u>immatriculation</u> , marque , modele , couleur , nbPlaces , _emailProprietaire_ )

**VILLE**
(<u>coordX</u> , <u>coordY</u> , nom , pays , codePostale , Region )

**TRAJET**
( <u>numT</u> , prixParKm , date_dep , date_ar , adr_rdv , adr_dep , _conducteur_ , _VehiculeImm_ ,  _villeDepX_ ,  _villeDepY_ , _villeArrX_ , _villeArrY_ , _numTrajetType_ )

**ETAPES**
( <u>_numT_</u> , <u>_coordX_</u> , <u>_coordY_</u> , _numTrajetLié_ )

**ACHETE**
( <u>_numT_</u> , <u>_numCovoitureur_</u> , prix )

**TRAJET_TYPE**
( <u>numTT</u> , prixParKm , _villeDepX_ ,  _villeDepY_ , _villeArrX_ , _villeArrY_ , _emailAdmin_ )

**AVIS**
( <u>_numT_<u> , <u>_numDonneur_</u> , <u>_numRéceveur_</u> )

*********************
