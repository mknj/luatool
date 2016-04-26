ds_pin = 4
ow.setup(ds_pin)
function tt()
  ow.reset_search(ds_pin)
  addr = ow.search(ds_pin)  
  print("scan")
  while (addr ~= nil) do
    print("found")

    ow.reset(ds_pin)
    ow.select(ds_pin, addr)
    ow.write(ds_pin, 0x44, 1)
    tmr.delay(1000000)

    data = {}
    ow.reset(ds_pin)
    ow.select(ds_pin, addr)
    ow.write(ds_pin, 0xBE, 1)
    for i = 1, 9 do data[i] = ow.read(ds_pin) end
    local tt
    tt=data[2]
    if tt >= 128 then
	tt=tt-256
    end
    temp = (data[1] + 256 * tt)*625
    data = {}
    for i = 1, #addr do data[i] = string.format("%02X", addr:byte(i)) end 
    print("/ow/"..table.concat(data, ':').."/temp",string.format("%i.%04i",temp/10000,temp%10000),0,0)

    addr = ow.search(ds_pin)
  end
  print("end")
end
