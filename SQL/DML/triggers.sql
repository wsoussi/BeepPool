-- Vérifie si un inscrit est bloqué ou pas


CREATE OR REMPLACE TRIGGER ctrl_blocage_compte
  BEFORE INSERT OR DELETE OR UPDATE ON INSCRIT
DECLARE	MESSAGE	EXCEPTION;
BEGIN
  IF OLD.email ="emailPHP" AND OLD.estBloque = 1
    THEN	RAISE MESSAGE;
  END	IF;
  EXCEPTION
    WHEN	MESSAGE	THEN
    RAISE_APPLICATION_ERROR(-20324,"Vous êtes bannis, impossible de modifier votre compte");
END;
