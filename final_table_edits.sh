#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

$PSQL "ALTER TABLE properties DROP COLUMN type"
$PSQL "DELETE FROM properties WHERE atomic_number=1000"
$PSQL "DELETE FROM elements WHERE atomic_number=1000"