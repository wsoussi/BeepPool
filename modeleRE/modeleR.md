#MODÈLE RELATIONEL DE LA BDD

**INSCRIT**
(<u>email</u> , nom , prenom , dateNaiss , adresse , codePostale , pays , numTel , mdp, estAdmin )

**VOITURE** (<u>immatriculation</u> , marque , modele , annee , couleur , nbPlaces , _emailProprietaire_ )

**VILLE**
(<u>coordX</u> , <u>coordY</u> , nomV , pays , codePostale , region )

**TRAJET_TYPE**
( <u>numTT</u> , prixParKm , _villeDepX_ ,  _villeDepY_ , _villeArrX_ , _villeArrY_ , _emailAdmin_ )

**TRAJET**
( <u>numT</u> , prixParKm , date_dep , date_ar , adr_rdv , adr_dep , _conducteur_ , _vehiculeImm_ ,  _villeDepX_ ,  _villeDepY_ , _villeArrX_ , _villeArrY_ , _numTrajetType_ )

**ETAPES**
( <u>_numT_</u> , <u>_coordX_</u> , <u>_coordY_</u> , _numTrajetLié_ )

**PARTECIPER**
( <u>_numT_</u> , <u>_emailCovoitureur_</u> )


**AVIS**
( <u>_numT_<u> , <u>_numDonneur_</u> , <u>_numRéceveur_</u> )
