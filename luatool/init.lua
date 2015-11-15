dofile("konfig.lua")
--dofile("temperature.lua")
--dofile("button.lua")
dofile("mqtt.lua")
--LED=4
--gpio.mode(LED,gpio.OUTPUT)
--gpio.write(LED,gpio.LOW)
wd=0
print("timer 6: WIFI watchdog")
tmr.alarm(6,1000,1,function()
	if(wd>60) then
		node.restart()
	end
	wd=wd+1
	if(wifi.sta.status()==5) then
		tmr.stop(6)
		mqttserver()
	end
end)
