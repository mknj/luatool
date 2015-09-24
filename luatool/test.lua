-- i.e. 
-- mosquitto_pub -h $IP -t $ID/test.lua -f test.lua 
-- mosquitto_pub -h $IP -t $ID/cmd -m 'dofile("test.lua")'
-- WARNING: filesize must be <1000 bytes

X=422
m:publish("/uptime","alice"..X,0,0,x)
