-- Exemple de création de villes
INSERT INTO ville(coordX,coordY,nomV,pays,codePostale,region)
VALUES (43.6109200,3.8772300, "Montpellier", "France", 34000, "Occitanie");

INSERT INTO ville(coordX,coordY,nomV,pays,codePostale,region)
VALUES (43.2969500,5.3810700, "Marseille", "France", 13000, "Provence-Alpes-Côte d'Azur");


-- Exemple de création de trajet type
INSERT INTO trajet_type(prixParKm, villeDepX, villeDepY, villeArrX, villeArrY, email_admin)
VALUES (0.1,43.6109200,3.8772300,  43.2969500, 5.3810700, "admin1@beeppool.fr");

-- Exemple de modification d'un memebre en admin
UPDATE inscrit SET estAdmin = 1 WHERE email = "email@server.domain";

-- Exemple de blockage d'un inscrit
UPDATE inscrit SET estBloque = 1 AND dateFinBlockage = GETDATE() + "nombre de semaine" WHERE email = "email@server.domain";
