#!/bin/sh

cmd=$(which tmux)
session="develop"

if [ -z $cmd ];then
	echo "You need to install tmux"
	exit 1
fi

#$cmd has -t $session 2> /dev/null
$cmd has -t $session 

if [ $? != 0 ];then
	$cmd new -d -n dev1 -s $session "ssh liminghao@10.6.17.69"
	$cmd splitw -h -t $session:0 "ssh liminghao@10.6.17.69"
	
	$cmd neww -n dev2 -t $session "ssh liminghao@10.6.32.6"
	$cmd splitw -h -t $session:1 "ssh liminghao@10.6.32.6"
	
	$cmd neww -n "dev1&&2" -t $session "ssh liminghao@10.6.17.69"
	$cmd splitw -h -t $session:2 "ssh liminghao@10.6.32.6"

	$cmd neww -n "dev1&&2" -t $session "ssh liminghao@10.6.17.69"
	$cmd splitw -h -t $session:3 "ssh liminghao@10.6.32.6"
	
	$cmd neww -n d1 -t $session "ssh liminghao@10.6.17.69"
	$cmd neww -n d1 -t $session "ssh liminghao@10.6.17.69"
	
	$cmd neww -n d2 -t $session "ssh liminghao@10.6.32.6"
	$cmd neww -n d2 -t $session "ssh liminghao@10.6.32.6"
	
	$cmd neww -n jump -t $session "bash"
	$cmd neww -n jump -t $session "bash"

	$cmd selectw -t $session:0
fi

$cmd att -t $session

exit 0

