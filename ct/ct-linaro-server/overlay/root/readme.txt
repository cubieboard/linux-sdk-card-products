The name of WIFI drive module is bcmdhd ,you can use command "lsmod " see that it has been loading . 
Use command "iwlist wlan0 scan" can find the WIFI hotspot you want to connect .
Add the ssid and passwd into /etc/network/interfaces .

Beacuse first connect ,after reboot the board ,maybe need type:

#ifconfig wlan0 down
#ifconfig wlan0 up
#/etc/init.d/networking restart 

