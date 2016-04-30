LED=4
gpio.mode(LED,gpio.OUTPUT)
sub("led",function(data) gpio.write(LED,data=="0" and gpio.LOW or gpio.HIGH) end)
