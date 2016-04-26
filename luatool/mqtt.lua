m = mqtt.Client(ID, 120, USER,PW)
m:lwt(ID.."/status","off",1,1)
subs={}
t0=0
sub=function(t,f)
	t=ID.."/"..t
	subs[t]=f
	if t0>0 then m:subscribe(t,0) end
end
pub=function(t,s,q,r) m:publish(ID.."/"..t,s,q or 0,r or 0) end
function mqttserver()
wd=0
function p()
	if(wd==1) then node.restart() end
	wd=1
	m:publish(ID.."/uptime",node.heap().." "..tmr.time(),0,0)
end
m:connect(IP, 1883, 0, function(c) 
	m:on("offline", function(c) node.restart() end)
	pub("status","on",0,1)
	for k,v in pairs(subs) do m:subscribe(k,0) end
	t0=1
	print("MQTT ok") 
        sub("cmd",function(data) node.input(data.."\r\n") end)
	sub("test.lua",function(data)
		file.remove("test.lua")
		file.open("test.lua","w")
		file.write(data)
		file.close()
	end)
	m:subscribe(ID.."/uptime",0)
	m:on("message", function(c, topic, data) 
		wd=0
		local f=subs[topic]
		if f ~= nil then
			f(data)
		end
	end)
	p()
end)
print("timer 6: MQTT watchdog")
tmr.stop(6)
tmr.alarm(6,100000, 1, p)
end
