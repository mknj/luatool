local LED_PIN=4
local LEDS=16
function conv(data)
  local l=string.len(data or "")
  local i
  if(l>LEDS*3) then l=LEDS*3 end
  buffer = ""
  for i = 1, l do
    local d=(string.byte(data,i)-48)*25
    if d<0 then d=0 end
    if d>255 then d=255 end
    buffer = buffer .. string.char(d)
  end
  for i = l+1, LEDS*3 do
    buffer = buffer .. string.char(0,0,0)
  end
  return buffer
end

sub("ws2812",function(data)
    ws2812.writergb(LED_PIN, conv(data))
end)
sub("ws2812n",function(data)
    local l=string.len(data or "")
    if l>4 then
      local i=tonumber(string.sub(data,4))
      if (i or 0) < 1 then i=0 end
      if i > LEDS  then i=LEDS end
      ws2812.writergb(LED_PIN, conv(string.sub(data,1,3):rep(i)))
    end
end)

