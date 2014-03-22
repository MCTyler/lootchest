#!/bin/bash
# /etc/init.d/minecraft
# version 0.3.9 2012-08-13 (YYYY-MM-DD)

### BEGIN INIT INFO
# Provides:   minecraft
# Required-Start: $local_fs $remote_fs
# Required-Stop:  $local_fs $remote_fs
# Should-Start:   $network
# Should-Stop:    $network
# Default-Start:  2 3 4 5
# Default-Stop:   0 1 6
# Short-Description:    Minecraft server
# Description:    Starts the minecraft server
### END INIT INFO

#Settings
SERVICE='lcdev.jar'
OPTIONS='nogui'
USERNAME='lcmc'
WORLD='world'
MCPATH='/home/lcmc/lcdev'
BACKUPPATH='/media/remote.share/minecraft.backup'
PERMSIZE=512
MAXHEAP=12
MINHEAP=2
HISTORY=1024
CPU_COUNT=2
INVOCATION="java -Xmx${MAXHEAP}G -Xms${MINHEAP}G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:PermSize=${PERMSIZE}m -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=$CPU_COUNT -XX:+AggressiveOpts -jar $SERVICE $OPTIONS"

ME=`lcdev`
as_user() {
  if [ $ME == $USERNAME ] ; then
    bash -c "$1"
  else
    su - $USERNAME -c "$1"
  fi
}

if  pgrep -u $USERNAME -f $SERVICE > /dev/null then
  echo "$SERVICE is already running!"
else
  echo "Starting $SERVICE..."
  cd $MCPATH
  as_user "cd $MCPATH && screen -h $HISTORY -dmS lootchest $INVOCATION"
  sleep 7
if pgrep -u $USERNAME -f $SERVICE > /dev/null then
  echo "$SERVICE is now running."
else
  echo "Error! Could not start $SERVICE!"
fi
fi