#!/bin/bash
# Example backup script for FTB server
# Author: Ciaran Crocker <ciarancrocker@gmail.com>
#Settings
SERVICE='lcdev.jar'
OPTIONS='nogui'
USERNAME='lcmc'
WORLD='world'
MCPATH='/home/lcmc/lcdev'
BACKUPPATH='/lcmc/backups/lootchest.backup'
NOW=`date "+%Y-%m-%d_%Hh%M"`
BACKUP_FILE="$BACKUPPATH/${WORLD}_${NOW}.tar"
ME=`lcmc`
as_user() {
  if [ $ME == $USERNAME ] ; then
    bash -c "$1"
  else
    su - $USERNAME -c "$1"
  fi
}
 

mc_saveoff() {
  if pgrep -u $USERNAME -f $SERVICE > /dev/null
  then
    echo "$SERVICE is running... suspending saves"
    as_user "screen -p 0 -S lootchest -X eval 'stuff \"say SERVER BACKUP STARTING. Server going readonly...\"\015'"
    as_user "screen -p 0 -S lootchest -X eval 'stuff \"save-off\"\015'"
    as_user "screen -p 0 -S lootchest -X eval 'stuff \"save-all\"\015'"
    sync
    sleep 10
  else
    echo "$SERVICE is not running. Not suspending saves."
  fi
}

mc_saveon() {
  if pgrep -u $USERNAME -f $SERVICE > /dev/null
  then
    echo "$SERVICE is running... re-enabling saves"
    as_user "screen -p 0 -S lootchest -X eval 'stuff \"save-on\"\015'"
    as_user "screen -p 0 -S lootchest -X eval 'stuff \"say SERVER BACKUP ENDED. Server going read-write...\"\015'"
  else
    echo "$SERVICE is not running. Not resuming saves."
  fi
}



mc_saveoff
echo "Backing up minecraft world..."
#as_user "cd $MCPATH && cp -r $WORLD $BACKUPPATH/${WORLD}_`date "+%Y.%m.%d_%H.%M"`"
as_user "tar -C \"$MCPATH\" -cf \"$BACKUP_FILE\" $WORLD"

echo "Backing up $SERVICE"
as_user "tar -C \"$MCPATH\" -rf \"$BACKUP_FILE\" $SERVICE"
#as_user "cp \"$MCPATH/$SERVICE\" \"$BACKUPPATH/minecraft_server_${NOW}.jar\""

mc_saveon

echo "Compressing backup..."
as_user "gzip -f \"$BACKUP_FILE\""
echo "Done."
 
# Jobs a good 'un