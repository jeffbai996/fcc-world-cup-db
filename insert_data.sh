#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Clear data from table before loading
echo $($PSQL "TRUNCATE games, teams")


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # check if header row
  if [[ $YEAR != year ]]
  then
    # insert years
    INSERT_YEAR_RESULT=$($PSQL "INSERT INTO games(year) VALUES('$YEAR')")
    if [[ $INSERT_YEAR_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted year into games, $YEAR
    fi
  fi

  # check if header row
  if [[ $ROUND != round ]]
  then
    # insert round
    INSERT_ROUND_RESULT=$($PSQL "INSERT INTO games(round) VALUES('$ROUND')")
    if [[ $INSERT_ROUND_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted round into games, $ROUND
    fi
  fi

  # check if header row
  if [[ $WINNER != winner ]]
  then
    # get winner id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert team
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted winning team into teams, $WINNER
      fi
    fi
  fi

  # check if header row
  if [[ $OPPONENT != opponent ]]
  then
    # get opponent id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert team
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted opponent team into teams, $OPPONENT
      fi
    fi
  fi

  # check if header row
  if [[ $WINNER_GOALS != winner_goals ]]
  then
    # insert winner goals
    INSERT_WINNERGOALS_RESULT=$($PSQL "INSERT INTO games(winner_goals) VALUES('$WINNER_GOALS')")
    if [[ $INSERT_WINNERGOALS_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted winner_goals into games, $WINNER_GOALS
    fi
  fi
  
  # check if header row
  if [[ $OPPONENT_GOALS != opponent_goals ]]
  then
    # insert winner goals
    INSERT_OPPONENTGOALS_RESULT=$($PSQL "INSERT INTO games(opponent_goals) VALUES('$OPPONENT_GOALS')")
    if [[ $INSERT_OPPONENTGOALS_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted opponent_goals into games, $OPPONENT_GOALS
    fi
  fi
done
