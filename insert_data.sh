#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Agregar permisos: "chmod +x insert_data.sh" y "chmod +x queries.sh"

# Capturar: year,round,winner,opponent,winner_goals,opponent_goals

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    #get team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    #if not found
    if [[ -z $WINNER_ID ]]
    then
      #insert to teams
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
       echo Inserted into teams, $WINNER
       WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      fi
    fi
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    #get team_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      #insert to teams
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
       echo Inserted into teams, $OPPONENT
       OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      fi
    fi
  fi

  if [[ $YEAR != "year" ]]
  then
    #insert game
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)")
    echo Inserted into games, $YEAR, $ROUND, $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID
  fi
done
