#!/bin/sh

cmd=$(which tmux)
session="redis0"

if [ -z $cmd ];then
	echo "You need to install tmux"
	exit 1
fi

#$cmd has -t $session 2> /dev/null
$cmd has -t $session

if [ $? != 0 ];then
	$cmd new -d -n all -s $session "ssh ttyc@10.10.112.240"
	$cmd splitw -v -p 66 -t $session:0 "ssh ttyc@10.10.110.38"
	$cmd splitw -v -t $session:0 "ssh ttyc@10.10.104.21"
	
	$cmd neww -n all -t $session "ssh ttyc@10.10.112.240"
	$cmd splitw -h -p 66 -t $session:1 "ssh ttyc@10.10.110.38"
	$cmd splitw -h -t $session:1 "ssh ttyc@10.10.104.21"
	
	$cmd neww -n jump -t $session "bash"

	$cmd neww -n r0 -t $session "ssh ttyc@10.10.112.240"
	$cmd neww -n r1 -t $session "ssh ttyc@10.10.110.38"
	$cmd neww -n r2 -t $session "ssh ttyc@10.10.104.21"
	
	$cmd neww -n jump -t $session "bash"
	$cmd neww -n jump -t $session "bash"

	$cmd selectw -t $session:0
fi

$cmd att -t $session

exit 0

