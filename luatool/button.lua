pin = 3
gpio.mode(pin,gpio.INPUT,gpio.PULLUP)
old=gpio.read(pin)

function checker()
  new=gpio.read(pin)
  if old~=new then
    pub("button",1-new,0,0)
  end
  old=new
end

tmr.alarm(5,100,1,checker)
print("timer 5: button checker")
