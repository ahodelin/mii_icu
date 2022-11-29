# Mapping of biosignalparameter of COPRA6 with the FHIR-profils of the ICU modul

On this repository are the used script to develop the master thesis "Wissenschaftliche Nachnutzung der Biosignaldaten aus der Routineversorgung in einem deutschen Universitätsklinikum". 

- python: Python Script for fuzzy-search and the CSV files with the parameter of the configuration variables and the profile name.
- sql: dump-file of the database to perform the work and SQL scripts to map the configuration variables with the FHIR-Profiles

## python

### csv
- __config_vars_names.csv__ names and descriptions of the configuration variables
- __profils_names.csv__ names of the FHIR-profils
- __string_search_set_to_transform.csv__ output of the python script with the pairs of the configuration variables with the FHIR-profiles

### python
- __string_search_set_token_to_csv.py__ script to perform the fuzzy search
- `python3 string_search_set_token_to_csv.py > string_search_set_token_to_csv.py` command to perform the fuzzy search and to save the result

## sql
This project was performed on a Ubuntu server with PostgreSQL.

### db
__mii_copra_db.sql__ is the dump file of the Postgres database mii_copra. To restore this database on a PostgreSQL server falows these steps:

1. `[sudo] su - database_user` __ change to the user postgres or any user with permission on the database server. This step is optional
2. `psql [-d some_database -U database_user -p port]` connect to the database [some_database as user database_user with the proxy port] the default options are postgres postgres 5432
3. `create database mii_copra` to create an empty database.
4. `\q` to exit
5. `psql -f /path/of/mii_copra_db.sql -d mii_copra [-U database_user -p port]` to reload the script into the database mii_copra.

### scripts
- __copra_config_var_quantities.sql__ script to select the configuration variables with 1000 or more validated, not deleted and current data on the values tables.
- __mapping_analyse.sql__ script to select the appropriate configuration variables for an FHIR profile.
- __views_to_transfer.sql__ views to link and visualize the data of the value tables

## Masterthesis

- __Masterarbeit_AbelHodelinHernandez_digitalSigned_24-11-2022.pdf__ Masterthesis in German
