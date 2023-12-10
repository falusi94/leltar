DO
$do$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'leltar') THEN
    CREATE USER leltar WITH PASSWORD 'leltar';
  END IF;
END
$do$;
