print("v4")
dofile("konfig.lua")
wd=0
m = mqtt.Client(ID, 120, USER,PW)
dofile("temperature.lua")
function server()
	t=0
	function x(c) end
	m:connect(IP, 1883, 0, function(c) 
		m:on("offline", function(con) node.restart() end)
		t=tmr.time()
		print("MQTT ok") 
		m:subscribe("/uptime",0, x)
		m:subscribe(ID.."/cmd",0, x)
		m:subscribe(ID.."/test.lua",0, x)
		m:on("message", function(c, topic, data) 
			wd=0
--			if data ~= nil then
--				print(topic.." "..string.len(data))
--			end
			if topic == ID.."/cmd" then
				node.input(data.."\r\n")
			end
			if topic == ID.."/test.lua" then
				file.remove("test.lua")
				f=file.open("test.lua","w")
				file.write(data)
				file.close()
			end
		end)
		wd=0
		p()
	end)
	function p()
		if(wd==1) then
			node.restart()
		end
		wd=1
		m:publish("/uptime",ID.." "..node.heap().." "..(tmr.time()-t),0,0,x)
	end
	tmr.stop(6)
	tmr.alarm(6, 60000, 1, p)
	print("wifi ok") 
end
print("timer 6: MQTT watchdog")
tmr.alarm(6,5000,1,function()
	if(wd>60) then
		node.restart()
	end
	wd=wd+1
	if(wifi.sta.status()==5) then
		tmr.stop(6)
		server()
	end
end)
