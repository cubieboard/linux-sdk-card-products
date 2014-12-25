#!/bin/sh
clear
OPTION_FILE="zte_options"
DIALER_SCRIPT=$(pwd)/zte_ppp_dialer
exec /usr/sbin/pppd file $OPTION_FILE connect "/usr/sbin/chat -v -f ${DIALER_SCRIPT}"

