#!/bin/bash
sysctl net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
ifconfig wlan2 192.168.0.1 netmask 255.255.255.0

