#!/usr/bin/lua
--version 1.0.0.0
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

if file_exists("/tmp/kamera") then return end
os.execute("touch /tmp/kamera")

local os = os
service = require "service"
revCamEnabled = false

while true do
	x=service.invoke("com.harman.service.Camera", "getAllProperties", {})
	if (x["reverse"] and (not revCamEnabled)) then
		revCamEnabled = true
		service.invoke("com.harman.service.LayerManager", "viewCameraInput", {})
	end
	if ((not x["reverse"] ) and revCamEnabled) then
		revCamEnabled = false
		service.invoke("com.harman.service.LayerManager", "stopCargoCameraInput", {})
	end
	os.sleep(0.1)
end
