wifi.setmode(wifi.STATION)
wifi.sta.config("XXX","XXXX")
mac="/"..wifi.sta.getmac()
function server()
t=0
m = mqtt.Client(mac, 120, "user", "password")
function x(c) end
m:connect("10.3.3.96", 1883, 0, function(c) 
  m:on("offline", function(con) node.restart() end)
  t=tmr.time()
  print("connected") 
  m:subscribe(mac.."/cmd",0, x)
  m:subscribe(mac.."/tst",0, x)
  m:on("message", function(c, topic, data) 
    if data ~= nil then
      print(topic.." "..string.len(data))
    end
    if topic == mac.."/cmd" then
      node.input(data.."\r\n")
    end
    if topic == mac.."/tst" then
      file.remove("test.lua")
      f=file.open("test.lua","w")
      file.write(data)
      file.close()
    end
  end)
  function p()
    m:publish("/uptime",mac.." "..node.heap().." "..(tmr.time()-t),0,0,x)
  end
  p()
  tmr.alarm(0, 60000, 1, p)
end)
end
tmr.alarm(0,1000,1,function()
if(wifi.sta.status()==5) then
tmr.stop(0)
server()
end
end)
