#!/bin/bash
PSQL="psql --tuples-only --username=freecodecamp --dbname=salon -c"
MAIN_MENU() {
  
  if [[ $1 ]]
  then
    echo -e "\n~~~~~ MY SALON ~~~~~"
    echo -e "\n$1\n"
  else
    echo -e "\n~~~~~ MY SALON ~~~~~"
    echo -e "\nWelcome to My Salon, how can I help you?\n"
  fi
  
  SERVICES=$($PSQL "SELECT * FROM services")
  echo $SERVICES | sed -E 's/([^ ]+) \| ([^ ]+) */\1) \2\n/g'
  read SERVICE_ID_SELECTED
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  
  if [[ -z $SERVICE ]]
  then
    MAIN_MENU "wat?"
  else
    echo -e "\nPhone?\n"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nwho dis?\n"
      read CUSTOMER_NAME
      ($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nWhen?\n"
    read SERVICE_TIME
    ($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "I have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU