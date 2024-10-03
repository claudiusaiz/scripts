#!/bin/bash
TC=$(which tc)
interface=eno1
interface_speed=100mbit
download_limit=64kbit
#download_limit=10
dst_IP=10.1.2.3

FILTER="$TC filter add dev $interface protocol ip parent 1: prio 1 u32"
function start_tc {
    tc qdisc show dev $interface | grep -q "qdisc pfifo_fast 0"
    [ "$?" -gt "0" ] && tc qdisc del dev $interface root; sleep 1
    $TC qdisc add dev $interface root handle 1: htb default 30
    $TC class add dev $interface parent 1: classid 1:1 htb rate $interface_speed  # burst 15k
    $TC class add dev $interface parent 1:1 classid 1:10 htb rate $download_limit # burst 15k
    $TC qdisc add dev $interface parent 1:10 handle 10: sfq perturb 10
    $FILTER match ip dst $dst_IP/32 flowid 1:10
}
function stop_tc {
    tc qdisc show dev $interface | grep -q "qdisc pfifo_fast 0"
    [ "$?" -gt "0" ] && tc qdisc del dev $interface root
}

function show_status {
        $TC -s qdisc ls dev $interface
}
function display_help {
        echo "Usage: tc [OPTION]"
        echo -e "\tstart - Apply the tc limit"
        echo -e "\tstop - Remove the tc limit"
        echo -e "\tstatus - Show status"
}

if [ -z "$1" ]; then
        display_help
elif [ "$1" == "start" ]; then
        start_tc
elif [ "$1" == "stop" ]; then
        stop_tc
elif [ "$1" == "status" ]; then
        show_status
fi
