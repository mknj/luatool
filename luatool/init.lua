GPIO = {[0]=3,[1]=10,[2]=4,[3]=9,[4]=1,[5]=2,[10]=12,[12]=6,[13]=7,[14]=5,[15]=8,[16]=0}
dofile("konfig.lua")
dofile("mqtt.lua")
if file.exists("temperature.lua") then
	dofile("temperature.lua")
end
if file.exists("button.lua") then
	dofile("button.lua")
end
if file.exists("led.lua") then
	dofile("led.lua")
end
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
