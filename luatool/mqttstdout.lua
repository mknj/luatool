-- i.e. 
-- mosquitto_pub -h $IP -t $ID/test.lua -f test.lua 
-- mosquitto_pub -h $IP -t $ID/cmd -m 'dofile("test.lua")'
-- WARNING: filesize must be <??? bytes 

function mqtt_out(str)
m:publish("/stdout",str,0,0,x)
end
node.output(mqtt_out,0)
print("ok")
