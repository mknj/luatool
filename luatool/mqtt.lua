m = mqtt.Client(ID, 120, USER,PW)
subs={}
sub=function(t,f)
	subs[ID..t]=f
	m:subscribe(ID..t,0, x)
end
pub=function(t,s)
	m:publish(ID..t,s,0,0)
end
function mqttserver()
	local t=0
	wd=0
	function x(c) end
	function p()
		if(wd==1) then node.restart() end
		wd=1
		m:publish(ID.."/uptime",node.heap().." "..(tmr.time()-t),0,0,x)
	end
	m:connect(IP, 1883, 0, function(c) 
		m:on("offline", function(con) node.restart() end)
		t=tmr.time()
		print("MQTT ok") 
		m:subscribe(ID.."/uptime",0, x)
		m:subscribe(ID.."/cmd",0, x)
		m:subscribe(ID.."/test.lua",0, x)
		m:on("message", function(c, topic, data) 
			wd=0
			local f=subs[topic]
			if f ~= nil then
				f(data)
			end
			if topic == ID.."/cmd" then
				node.input(data.."\r\n")
			end
			if topic == ID.."/test.lua" then
				file.remove("test.lua")
				file.open("test.lua","w")
				file.write(data)
				file.close()
			end
		end)
		p()
	end)
	print("timer 6: MQTT watchdog")
	tmr.stop(6)
	tmr.alarm(6, 60000, 1, p)
end
