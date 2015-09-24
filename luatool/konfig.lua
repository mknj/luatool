print("konfiguriere wlan")
wifi.setmode(wifi.STATION)
wifi.sta.config("SID","PASSWORD")
ID="/"..wifi.sta.getmac()
IP="YOUR_MQTT_SERVER_IP_ADDRESS"
USER="mqtt user"
PW="mqtt password"
