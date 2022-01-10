#!/usr/bin/lua
--testuje wykrywanie biegu wstecznego i wejscia video
local os            = os
os.execute("lua /fs/usb0/rev.lua &")

-- FINISH
os.execute("mount -ur /fs/mmc0/")
os.execute("mount -ur /fs/mmc1/")
os.execute(mountpath.."/usr/share/scripts/mmc.sh stop")
