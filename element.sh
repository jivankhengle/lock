#!/bin/bash
# Query the periodic_table database for element details.
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

ARG="$1"

# Support lookup by atomic number, symbol, or name.
ELEMENT=$($PSQL "SELECT e.atomic_number || '|' || e.name || '|' || e.symbol || '|' || t.type || '|' || trim(trailing '.' from trim(trailing '0' from p.atomic_mass::text)) || '|' || p.melting_point_celsius || '|' || p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number::text = '$ARG' OR lower(e.symbol) = lower('$ARG') OR lower(e.name) = lower('$ARG') LIMIT 1;")

if [[ -z "$ELEMENT" ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
