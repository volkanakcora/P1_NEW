DO
$do$
BEGIN
   IF NOT EXISTS ( SELECT FROM pg_roles
                   WHERE rolname = 'englobkpi') THEN
      CREATE ROLE englobkpi WITH LOGIN;
   END IF;
END
$do$;

SELECT 'CREATE DATABASE englobkpi WITH OWNER englobkpi' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'englobkpi')\gexec
