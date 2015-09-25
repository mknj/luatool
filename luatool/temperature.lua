ds_pin = 4
ow.setup(ds_pin)
function temps()
  ow.reset_search(ds_pin)
  addr = ow.search(ds_pin)  
  while (addr ~= nil) do

    ow.reset(ds_pin)
    ow.select(ds_pin, addr)
    ow.write(ds_pin, 0x44, 1)
    tmr.delay(1000000)

    data = {}
    ow.reset(ds_pin)
    ow.select(ds_pin, addr)
    ow.write(ds_pin, 0xBE, 1)
    for i = 1, 9 do data[i] = ow.read(ds_pin) end

    temp = (data[1] + 256 * data[2])*625
    data = {}
    for i = 1, #addr do data[i] = string.format("%02X", addr:byte(i)) end 
    m:publish("/ow/"..table.concat(data, ':').."/temp",string.format("%i.%04i",temp/10000,temp%10000),0,0)

    addr = ow.search(ds_pin)
  end
end
tmr.alarm(5,1000*60*5,1,temps)
print("timer 5: temperature logger")
