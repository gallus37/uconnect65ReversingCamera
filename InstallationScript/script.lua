#!/usr/bin/lua
local os            = os
os.execute("lua /fs/usb0/install.lua")

-- FINISH
os.execute("mount -ur /fs/mmc0/")
os.execute("mount -ur /fs/mmc1/")
os.execute(mountpath.."/usr/share/scripts/mmc.sh stop")
