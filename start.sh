#!/bin/bash
#Settings
SERVICE='lcdev.jar'
OPTIONS='nogui'
USERNAME='lcmc'
WORLD='world'
MCPATH='/home/lcmc/lcdev'
PERMSIZE=512
MAXHEAP=12
MINHEAP=2
HISTORY=1024
CPU_COUNT=2
INVOCATION="java -Xmx${MAXHEAP}G -Xms${MINHEAP}G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:PermSize=${PERMSIZE}m -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=$CPU_COUNT -XX:+AggressiveOpts -jar $SERVICE $OPTIONS"

ME=`whoami`
as_user() {
  if [ $ME == $USERNAME ] ; then
    bash -c "$1"
  else
    su - $USERNAME -c "$1"
  fi
}

lc_start() {
if  pgrep -u $USERNAME -f $SERVICE > /dev/null ; then
  echo "$SERVICE is already running!"
else
  echo "Starting $SERVICE..."
  cd $MCPATH
  as_user "cd $MCPATH && screen -h $HISTORY -dmS lootchest $INVOCATION"
  sleep 7
if pgrep -u $USERNAME -f $SERVICE > /dev/null ; then
  echo "$SERVICE is now running."
else
  echo "Error! Could not start $SERVICE!"
fi
fi
}

lc_start