#!/bin/bash
source /etc/profile

ENV="xxx"
app_flag="CPSITE_Myd_$ENV"

function appStart() {
  echo "call appStart()..."
  echo "starting... please wait"
  #pm2 startOrRestart ecosystem.json --only $app_flag
  pm2 start ecosystem.json --only $app_flag
  echo "nodejs start status: "$?
  sleep 1
  count=`pgrep -f "$app_flag" | wc -l`
  if [ $count -eq 0 ]; then
    echo `date +%Y-%m-%d%k:%M:%S`
    echo "start failed"
    return 0
  else
    echo `date +%Y-%m-%d%k:%M:%S`
    echo "start ok"
  fi
}

function appStop() {
  echo "call appStop()..."
  pid=`ps -ef | grep node | grep "$app_flag" | grep -v grep | grep -v bash | awk '{print $2}'`
  echo "current nodejs's pid is $pid, it will be stopped...please wait."
  echo `date +%Y-%m-%d%k:%M:%S`
  pm2 stop $app_flag
  pm2 delete $app_flag
  #pm2 kill
  echo "sleep start `date +%Y-%m-%d%k:%M:%S`"
  sleep 1
  echo "sleep stop `date +%Y-%m-%d%k:%M:%S`"
  count=`ps -p $pid | grep -v "PID TTY" | wc -l`
  if [ $count -eq 0 ]; then
    echo "stop ok"
    echo `date +%Y-%m-%d%k:%M:%S`
    return 2
  else
    echo "stop failed"
    echo `date +%Y-%m-%d%k:%M:%S`
    return 1
  fi
}
 
function check_pid() {
  echo "call check_pid()..."
  count=`ps -ef | grep node | grep "$app_flag" | grep -v grep | grep -v bash | grep -v service.sh | awk '{print $2}'|wc -l`
  echo $count
  if [[ $count != 0 ]]; then
    running=1
    return $running
  fi
  return 0
}
 
function start() {
  echo "call start()..."
  echo `date +%Y-%m-%d%k:%M:%S`
  
  appStart
  sleep 1
  pid=`ps -ef | grep node | grep "$app_flag" | grep -v grep | grep -v bash | awk '{print $2}'`
  count=`pgrep -f "$app_flag"`
  if [[ $count != "" ]];then
    echo "nodejs started, current pid is $pid..."
    echo `date +%Y-%m-%d%k:%M:%S`
    echo "MW_SUCCESS"
  else
    echo "nodejs failed to start."
    echo `date +%Y-%m-%d%k:%M:%S`
    return 1
  fi
}
 
function stop() {
  echo "call stop()..."
  appStop
  if [ $? != 2 ]; then
    check_pid
    if [ $? -gt 0 ]; then
      pid=`ps -ef | grep node | grep "$app_flag" | grep -v grep | grep -v bash | awk '{print $2}'`
      echo "exec kill -9 $pid"
      kill -9 $pid
      check $? "kill -9 $pid fail"
    fi
  fi
  echo "nodejs stopped..."
  if [ $# -eq 0 ]; then
    echo `date +%Y-%m-%d%k:%M:%S`
    echo "MW_SUCCESS"   
  fi
}
 
function restart() {
  echo "call restart()..."
  stop 1
  sleep 1
  start
}
 
function status() {
  echo "call status()..."
  check_pid
  running=$?
  if [ $running -gt 0 ]; then
    pm2 status
    echo started
  else
    echo stoped
  fi
}
 
function help() {
  echo "start|stop|restart|status"
}
 
function check() {
  if [ $1 != 0 ]; then
    echo "exec fail"
    echo "$2"
    exit 1
  fi
}
 
if [ "$1" == "" ]; then
  help
elif [ "$1" == "stop" ]; then
  stop
elif [ "$1" == "start" ]; then
  start
elif [ "$1" == "restart" ]; then
  restart
elif [ "$1" == "status" ]; then
  status
else
  help
fi