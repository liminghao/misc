#!/bin/sh

cmd=$(which tmux)
session="hadoop0"

if [ -z $cmd ];then
	echo "You need to install tmux"
	exit 1
fi

#$cmd has -t $session 2> /dev/null
$cmd has -t $session

if [ $? != 0 ];then
	$cmd new -d -n datanodes -s $session "ssh ttyc@10.10.107.36"
	$cmd splitw -h -t $session:0 "ssh ttyc@10.10.99.143"
	$cmd splitw -v -t $session:0 "ssh ttyc@10.10.98.101"
	$cmd splitw -v -t $session:0.0 "ssh ttyc@10.10.107.237"
	
	$cmd neww -n namenode -t $session "ssh ttyc@10.10.109.129"
	$cmd splitw -h -t $session:1 "ssh ttyc@10.10.109.129"
	
	$cmd neww -n jump -t $session "bash"

	$cmd neww -n allnodes -t $session "ssh ttyc@10.10.109.129"
	$cmd splitw -h -t $session:3 "ssh ttyc@10.10.99.143"
	$cmd splitw -v -p 66 -t $session:3 "ssh ttyc@10.10.98.101"
	$cmd splitw -v -t $session:3 "ssh ttyc@10.10.107.36"
	$cmd splitw -v -t $session:3.0 "ssh ttyc@10.10.107.237"

	$cmd neww -n allnodes -t $session "ssh ttyc@10.10.109.129"
	$cmd splitw -h -t $session:4 "ssh ttyc@10.10.99.143"
	$cmd splitw -v -p 66 -t $session:4 "ssh ttyc@10.10.98.101"
	$cmd splitw -v -t $session:4 "ssh ttyc@10.10.107.36"
	$cmd splitw -v -t $session:4.0 "ssh ttyc@10.10.107.237"

	$cmd neww -n datanodes -t $session "ssh ttyc@10.10.107.36"
	$cmd splitw -h -t $session:5 "ssh ttyc@10.10.99.143"
	$cmd splitw -v -t $session:5 "ssh ttyc@10.10.98.101"
	$cmd splitw -v -t $session:5.0 "ssh ttyc@10.10.107.237"
	
	$cmd neww -n h0 -t $session "ssh ttyc@10.10.109.129"
	$cmd neww -n h1 -t $session "ssh ttyc@10.10.99.143"
	$cmd neww -n h2 -t $session "ssh ttyc@10.10.107.237"
	$cmd neww -n h3 -t $session "ssh ttyc@10.10.98.101"
	$cmd neww -n h4 -t $session "ssh ttyc@10.10.107.36"
	
	$cmd neww -n jump -t $session "bash"
	$cmd neww -n jump -t $session "bash"

	$cmd selectw -t $session:0
fi

$cmd att -t $session

exit 0

