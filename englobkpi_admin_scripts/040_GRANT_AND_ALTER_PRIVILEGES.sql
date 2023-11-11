-- application user for public schema
\connect englobkpi;
-- default privileges (Default grants for new tables etc.)
ALTER DEFAULT PRIVILEGES FOR ROLE englobkpi IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO englobkpi;
ALTER DEFAULT PRIVILEGES FOR ROLE englobkpi IN SCHEMA public GRANT USAGE ON SEQUENCES TO englobkpi;
ALTER DEFAULT PRIVILEGES FOR ROLE englobkpi IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO englobkpi;
-- grants (For already existing tables etc.)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES in SCHEMA public TO englobkpi;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO englobkpi;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO englobkpi;
-- general grants
GRANT CONNECT ON DATABASE englobkpi TO englobkpi;
GRANT USAGE ON SCHEMA public TO englobkpi;


-- read only powerbi user for public schema
-- default privileges (Default grants for new tables etc.)
ALTER DEFAULT PRIVILEGES FOR ROLE englobkpi IN SCHEMA public GRANT SELECT ON TABLES TO powerbi;
ALTER DEFAULT PRIVILEGES FOR ROLE englobkpi IN SCHEMA public GRANT USAGE ON SEQUENCES TO powerbi;
-- grants (For already existing tables etc.)
GRANT SELECT ON ALL TABLES in SCHEMA public TO powerbi;
-- general grants
GRANT CONNECT ON DATABASE englobkpi TO powerbi;
GRANT USAGE ON SCHEMA public TO powerbi;
