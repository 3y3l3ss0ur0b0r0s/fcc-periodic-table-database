#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# for renaming columns in properties table
$PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass"
$PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius"
$PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius"
$PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL"
$PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL"

# for adding constraints to elements
$PSQL "ALTER TABLE elements ADD CONSTRAINT symbol_unique UNIQUE(symbol)"
$PSQL "ALTER TABLE elements ADD CONSTRAINT name_unique UNIQUE(name)"
$PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL"
$PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL"

# adding foreign key
$PSQL "ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number)"

# create types table and store the 3 types of elements
$PSQL "CREATE TABLE types(type_id SERIAL PRIMARY KEY, type VARCHAR NOT NULL)"
$PSQL "INSERT INTO types(type) SELECT DISTINCT type FROM properties"

# add type_id to properties table
$PSQL "ALTER TABLE properties ADD COLUMN type_id INT"
$PSQL "UPDATE properties SET type_id=types.type_id FROM types where properties.type=types.type"
$PSQL "ALTER TABLE properties ADD CONSTRAINT type_id_foreign_key FOREIGN KEY(type_id) REFERENCES types(type_id)"
$PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL"

# ---------- to fix formatting ----------

# capitalization
$PSQL "UPDATE elements SET symbol=INITCAP(symbol)"

# remove trailing zeros
$PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL"
$PSQL "UPDATE properties SET atomic_mass=atomic_mass::REAL"

# add the 2 specified elements to the database
$PSQL "INSERT INTO elements(atomic_number,symbol,name) VALUES(9,'F','Fluorine')"
$PSQL "INSERT INTO properties(atomic_number,atomic_mass,melting_point_celsius,boiling_point_celsius,type,type_id) VALUES(9,18.998,-220,-188.1,'nonmetal',3)"
$PSQL "INSERT INTO elements(atomic_number,symbol,name) VALUES(10,'Ne','Neon')"
$PSQL "INSERT INTO properties(atomic_number,atomic_mass,melting_point_celsius,boiling_point_celsius,type,type_id) VALUES(10,20.18,-248.6,-246.1,'nonmetal',3)"