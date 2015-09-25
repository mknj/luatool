pin = 3
gpio.mode(pin,gpio.INPUT,gpio.PULLUP)
old=gpio.read(pin)

function temps()
  new=gpio.read(pin)
  if old~=new then
    m:publish(ID.."/button",1-new,0,0)
  end
  old=new
end

tmr.alarm(5,100,1,temps)
print("timer 5: button checker")
