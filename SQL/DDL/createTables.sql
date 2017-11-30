create table inscrit
(
    email VARCHAR(320) constraint inscrit_pk primary key,
        -- 64 characters for the "local part" (username).
        -- 1 character for the @ symbol.
        -- 255 characters for the domain name.
    nom VARCHAR(30) constraint inscrit_nomNN not null,
    prenom VARCHAR(30) constraint inscrit_prenomNN not null,
    dateNaiss DATE constraint inscrit_dateNaissNN check dateNaiss is  not null and dateNaiss < CAST(CURRENT_TIMESTAMP AS DATE) and dateNaiss > (CAST(CURRENT_TIMESTAMP AS DATE) - (120*365)),
    adresse VARCHAR(70),
    codePostale VARCHAR(9),
        -- la longueur change de pays à pays (par example USA a 9 chiffres)
    pays VARCHAR(50),
    numTel VARCHAR(13),
    mdp VARCHAR(26),
    estAdmin BIT constraint inscrit_estAdmin DEFAULT 0
);

create table voiture
(
  immatriculation VARCHAR(8) constraint voiture_pk primary key,
      -- une immatriculation a une longueur variable par rapport au pays et date d'immatriculation
  marque VARCHAR(35) constraint voiture_marqueNN not null,
  modele VARCHAR(35) constraint voiture_modeleNN not null,,
  annee INTEGER constraint voiture_anneeConstr check annee >= 1883 and annee <= year(CAST(CURRENT_TIMESTAMP AS DATE));
      -- invention de l'automobile: 1883
  couleur VARCHAR(15),
  nbPlaces INTEGER constraint voiture_nbPlacesCheck nbPlaces is not null and nbPlaces <= 9,
  emailProprietaire VARCHAR(320) constraint voiture_emailProprietaireNN not null,
  constraint voiture_FK foreign key (emailProprietaire) references inscrit(email)
);

create table ville
(
    coordX DECIMAL,
    coordY DECIMAL,
    nom VARCHAR(100) constraint ville_nomNN not null,
    region  VARCHAR(100) constraint ville_regionNN not null,
    pays VARCHAR(50)constraint ville_paysNN not null,
    constraint ville_PK primary key (coordX, coordY)
);

create table trajet_type
(
    numTT INTEGER constraint trajet_type_PK primary key,
    prixParKm DECIMAL(3,2) constraint trajet_type_prixNN not null,
        -- je met le prix comme not null parce que
        -- dans notre vision c'est tout l'interet
        -- d'avoir la table trajet_type
    villeDepX DECIMAL constraint trajet_type_villeDepX_FK foreign key references ville(coordX),
    villeDepY DECIMAL constraint trajet_type_villeDepY_FK foreign key references ville(coordY),
    villeArrX DECIMAL constraint trajet_type_villeArrX_FK foreign key references ville(coordX),
    villeArrY DECIMAL constraint trajet_type_villeArrY_FK foreign key references ville(coordY),
    email admin VARCHAR(320) constraint trajet_type_admin_FK forein key references inscrit(email)
);

create table trajet
  (
    numT INTEGER constraint trajet_PK primary key,
    prixParKm DECIMAL(3,2) constraint trajet_prixNN not null,
    date_dep DATE constraint trajet_date_depNN check date_dep is not null and  date_dep >= CAST(CURRENT_TIMESTAMP AS DATE) and date_dep <= (CAST(CURRENT_TIMESTAMP AS DATE) + 182),
    date_ar DATE constraint trajet_date_ar check date_ar > date_dep,
  )
