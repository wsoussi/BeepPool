create table inscrit
(
    email VARCHAR(200),
        -- 64 characters for the "local part" (username).
        -- 1 character for the @ symbol.
        -- 255 characters for the domain name.
    nom VARCHAR(30) not null,
    prenom VARCHAR(30) not null,
    dateNaiss DATE not null,
    adresse VARCHAR(70),
    codePostale VARCHAR(9),
        -- la longueur change de pays à pays (par example USA a 9 chiffres)
    pays VARCHAR(50),
    numTel VARCHAR(13) not null,
    mdp VARCHAR(26),
    estAdmin BIT DEFAULT 0,
    dateFinBlockage DATE,
    primary key inscrit_pk (email)
);

create table voiture
(
  immatriculation VARCHAR(8),
      -- une immatriculation a une longueur variable par rapport au pays et date d'immatriculation
  marque VARCHAR(35) not null,
  modele VARCHAR(35) not null,
  annee INTEGER,
  couleur VARCHAR(15),
  nbPlaces INTEGER not null,
  emailProprietaire VARCHAR(200) not null,
  primary key voiture_pk (immatriculation),
  foreign key voiture_FK (emailProprietaire) references inscrit(email) on update cascade on delete cascade
);

create table ville
(
    coordX DECIMAL,
    coordY DECIMAL,
    nom VARCHAR(100) not null,
    region  VARCHAR(100) not null,
    pays VARCHAR(50)not null,
    primary key ville_PK (coordX, coordY)
);

create table trajet_type
(
    numTT INTEGER,
    prixParKm DECIMAL(3,2) not null,
        -- je met le prix comme not null parce que
        -- dans notre vision c'est tout l'interet
        -- d'avoir la table trajet_type
    villeDepX DECIMAL,
    villeDepY DECIMAL,
    villeArrX DECIMAL,
    villeArrY DECIMAL,
    email_admin VARCHAR(200),
    primary key trajet_type_PK (numTT),
    foreign key trajet_type_villeDep_FK (villeDepX,villeDepY) references ville (coordX,coordY) on update cascade on delete cascade,
    foreign key trajet_type_villeArrX_FK (villeArrX,villeArrY) references ville (coordX,coordY) on update cascade on delete cascade,
    foreign key trajet_type_admin_FK (email_admin) references inscrit (email) on update cascade on delete cascade
);

create table trajet
  (
    numT INTEGER auto_increment,
    prix DECIMAL(4,2) not null,
    date_dep DATE not null,
    date_ar DATE not null,
    adr_rdv VARCHAR(70) not null,
    adr_ar VARCHAR(70) not null,
    conducteur VARCHAR(200) not null,
    vehiculeImm VARCHAR(8) not null,
    nbPlace INTEGER(50) not null,
    villeDepX DECIMAL not null,
    villeDepY DECIMAL not null,
    villeArrX DECIMAL not null,
    villeArrY DECIMAL not null,
    numTrajetType INTEGER,
    primary key trajet_PK (numT),
      foreign key trajet_conducteur_FK (conducteur) REFERENCES inscrit(email),
      foreign key trajet_vehiculeImm_FK (vehiculeImm) REFERENCES voiture(immatriculation),
      foreign key trajet_villeDep_FK (villeDepX,villeDepY) REFERENCES ville(coordX,coordY),
      foreign key trajet_villeArr_FK (villeArrX,villeArrY) REFERENCES ville(coordX,coordY),
      foreign key trajet_numTrajetType_FK (numTrajetType) REFERENCES trajet_type(numTT)
);

create table etapes
(
  numT INTEGER,
  coordX DECIMAL,
  coordY DECIMAL,
  numTrajetLie  INTEGER,
    constraint etapes_PK primary key (numT, coordX, coordY),
    foreign key etapes_numT_FK (numT) references trajet(numT),
    foreign key etapes_coord_FK (coordX,coordY) references ville(coordX,coordY)
);

create table participer
(
  numT INTEGER,
  numCovoitureur VARCHAR(200),
  primary key participer_PK (numT, numCovoitureur),
  foreign key participer_numCovoitureur_FK (numCovoitureur) references inscrit(email),
  foreign key participer_numT_FK (numT) references trajet(numT)
);

create table avis
  (
    numT INTEGER,
    numDonneur VARCHAR(200),
    numReceveur VARCHAR(200),
    nbEtoile INTEGER(1) not null,
    commentaire VARCHAR(200),
    primary key avis_PK (numT, numDonneur, numReceveur),
    foreign key participer_numDonneur_FK (numDonneur) references inscrit(email),
  foreign key avis_numT_FK (numT) references trajet(numT),
    foreign key participer_numReceveur_FK (numReceveur) references inscrit(email)
  );
