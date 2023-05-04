#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # echo $YEAR, $ROUND, $WINNER, $OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS

    # populate teams teable

    # get winner id and opponent id from teams
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

    # if not found add
    if [[ -z $WINNER_ID ]]
    then
      WINNER_ADDED=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")

      : '  
      if [[ $WINNER_ADDED == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER.
      fi
      '
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    fi

    if [[ -z $OPPONENT_ID ]]
    then
      OPPONENT_ADDED=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      
      : '
      if [[ $OPPONENT_ADDED == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT_ADDED.
      fi
      '
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    fi

      echo Populated the teams table.
    # populate games table

    POPULATE_TABLE=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
    if [[ $POPULATE_TABLE == 'INSERT 0 1' ]]
    then
      echo Populated the games table.
    fi
  fi
done
