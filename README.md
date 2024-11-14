# Derek the Ender-3 V2

TODO: description

## Mods/Parts
* [Derekputer](https://www.aliexpress.com/item/1005005785846814.html)
* [BLTouch](https://www.123-3d.co.uk/Antclabs-BLTouch-Auto-Bed-Levelling-Sensor-v3-1-BLTOUCH-i3640-t19122.html)
* [Hotend Fan](https://amzn.eu/d/3sNrajx)
* [LED Strips](https://www.aliexpress.com/item/1005003279313941.html)
* [BLTouch Mount](./Models/BLTouch%20Mount.stl)
* [LED Mount](./Models/LED%20Mount.stl)
* [Z-Axis Mount](./Models/Z-Axis%20Mount%20(+-0.2mm).stl)
* [Z-Axis Camera Mount](./Models/Z-Axis%20Camera%20Mount%20(+-0.2mm).stl)
* [PET/PEI Magnetic Build Plate](https://www.aliexpress.com/item/1005005536007858.html)

## Derekputer Docker Containers (TODO)
* [Proxy](https://github.com/Lyall-A/HTTP-Reverse-Proxy)
* [OctoPrint](https://octoprint.org/)
* [Derek Cam](https://github.com/Lyall-A/Derek-Cam)
* [Derek PSU](https://github.com/Lyall-A/Derek-PSU)

## Local Links
* [OctoPrint](http://octoprint.derekputer)
* [Derek Cam](http://cam.derekputer)
* [Derek Cam (Stream)](http://stream.derekputer)
* [Derek Cam (Still)](http://still.derekputer)
* 
## Public Links
* [OctoPrint](http://derek.lyall.lol)
* [Derek Cam](http://derek-cam.derekputer)
* [Derek Cam (Stream)](http://derek-stream.derekputer)
* [Derek Cam (Still)](http://derek-still.derekputer)

## Random info
* Derekputer is a Orange Pi Zero 3 with 4GB RAM
* Derek Cam is a random ass webcam I got years ago
* The 24v hotend fan is replaced with a 5v Noctua fan connected to BLTouch power connector
* The BLTouch connector on the mainboard is mostly soldered, wires being soldered from the connector pins on the back of the mainboard to 2 2-pin terminal blocks
* The LCD cable ground wire is fucked from me and a knife, I didn't add any more wire when resoldering so the ground wire specifically is shorter
* The AUX fan is slightly fucked, got a free replacement from Creality and within seconds fucked that one too :)

## TODO's
* ~~Change the popup that shows on the LCD during boot, seems to be in the binary at [Marlin/lib/proui/stm32f1/libproui_ubl_dwin.a](https://github.com/Lyall-A/Derek-Firmware/tree/main/Marlin/lib/proui/stm32f1/libproui_ubl_dwin.a)~~ doesn't seem to be possible
* ~~Get Derek OS running from Debian with custom Linux kernel tweaks~~
* ~~Derek Cam script + offline and error jpegs~~
* Fix Derekputer going offline after a few days/weeks (create watchdog script?)