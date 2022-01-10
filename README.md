# uconnect65ReversingCamera
Reversing camera for uConnect 6.5"

# Disclaimer
All below-described actions can render car's stereo completly disabled, scripts were tested, but it cannot be ensured that these work on all nor any hardware/software combination. Proceed at own risk.

# Intro
To execute scripts on uConnect device please follow instructions from XDA forum: https://forum.xda-developers.com/t/uconnect-6-5-alfa-fiat-root-access.3828426/
Basically one need modified swdl.iso from linked Mega drive `1 Magic Files`->`1 Magic - Alfa pre UPD (17.07.55).zip` this file (swdl.iso) should be placed in root directory of FAT32-formatted pendrive with at least 4GB of capacity. If this is true, then `script.lua` will be executed. After execution user is prompted to proceed with software update, to which **one shall answer NO**. It is recommended to switch on radio with button and wait approximately 2 minutes for boot process to finish (estabilished bluetooth connection to smartphone is good indicator of finished boot) before inserting flash drive into USB socket.

# Test
In folder TestScript there is pair of scripts that would test if this method would work on particular radio without any permanent modifications. Files script.lua and rev.lua should be placed alongside swdl.iso on pendrive's root. Script will work until radio is switched off, which happens roughly 30 seconds after manual/ignition/timeout triggered switch off.

# Installation
To permanently install script please use scripts from folder InstallationScript. This will place rev.lua script on internal flash storage of uConnect and modify boot.sh file to start is as soon as radio is switched on. Original boot.sh is backed up to pendrive, also log of operations is created there.

# Video input test
Execute scipt as described in Test paragraph. After that, with ignition ON, radio should switch to video input as soon as reverse gear is selected. In case when no video signal is present then solid blue screen is presented. Any video source can be used for test such as older camera or smartphone. Signal standard is PAL composite https://en.wikipedia.org/wiki/Composite_video not sure how about NTSC. Connections are pins 31/32 as described in https://pinoutguide.com/Car-Stereo-Chrysler-Fiat/Dodge_Charger_2015-2019_H_pinout.shtml
