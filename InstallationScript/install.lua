#!/usr/bin/lua
local version = "1.0.0.0"
local boot_sh_path_const = "/fs/mmc0/app/bin/boot.sh"
local rev_lua_path_const = "/fs/mmc0/app/bin/rev.lua"
local insert_after_line_const = "mount -T io-pkt lsm-tun-v4.so"
local line_to_insert_const = "[ -f "..rev_lua_path_const.." ] && lua "..rev_lua_path_const.." &"
local log_cache = {}
local working_dir = "/fs/usb0/"
local rev_lua= [[
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
]]
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function read_lines(file)
  if not file_exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function find_line(lines, toFind)
  for i, line in ipairs(lines) do
    if line == toFind then return i end
  end
  return -1
end

function find_in_lines(lines, toFind)
  for i, line in ipairs(lines) do
    if string.find(line, toFind)~=nil then return i end
  end
  return -1
end

function log(toLog)
  log_cache[#log_cache+1] = toLog
  print(toLog)
end

function writeLog()
  local file = io.open(working_dir.."log.txt", "a")
  io.output(file)
  for i, line in ipairs(log_cache) do
    io.write(line,"\r\n")
  end
  io.close(file)
end

function write_lines(lines, file)
  local file = io.open(file, "w")
  io.output(file)
  for i, line in ipairs(lines) do
    io.write(line,"\n")
  end
  log("...wrote " .. file:seek("end") .. "B")
  io.close(file)
end

function write_string(toWrite, file)
  local file = io.open(file, "w")
  io.output(file)
  io.write(toWrite)
  log("...wrote " .. file:seek("end") .. "B")
  io.close(file)
end

--Main function
log("Script version "..version.." started at: "..os.date("%Y-%m-%d %H:%M:%S"))
backupSuffix = os.date("%Y%m%d%H%M%S")
log("Backing-up boot.sh to "..working_dir.."boot.sh_"..backupSuffix)
os.execute("cp "..boot_sh_path_const.." "..working_dir.."boot.sh_"..backupSuffix)

log("Writing rev.lua to \""..rev_lua_path_const.."\"...")
write_string(rev_lua, rev_lua_path_const)

log("Reading boot.sh from " .. boot_sh_path_const.."...")
boot_sh = read_lines(boot_sh_path_const)
log("..."..#boot_sh .. " lines read.")

log("Checking if line to insert is already present in boot.sh...")
if find_in_lines(boot_sh, line_to_insert_const) == -1 then
  log("...line not found, looking for place to insert...")
  lineIndex = find_line(boot_sh, insert_after_line_const)
  if lineIndex == -1 then log("...!ERROR! Cannot find place to add")
  else
    lineIndex=lineIndex+1
    log("...inserting at line " .. lineIndex)
    table.insert(boot_sh, lineIndex, line_to_insert_const)
    log("Writing boot.sh to \""..boot_sh_path_const.."\"...")
    write_lines(boot_sh, boot_sh_path_const)
  end  
else log("...\""..line_to_insert_const.. "\" already present in boot.sh") end
writeLog()