---
--- Created by SHsuperCM.
--- DateTime: 11/08/2025 11:38
---

filesystem.initFileSystem("/d")

local bootloader

for _, drivename in pairs(filesystem.children("/d")) do
    filesystem.mount("/d/" .. drivename, "/")
    if filesystem.isFile("/boot/bootloader.lua") then
        print("Booting from drive: " .. drivename)
        bootloader = filesystem.loadFile("/boot/bootloader.lua")
        break
    end
    filesystem.unmount("/")
end

if bootloader == nil then
    print("Could not find bootloader drive!")
    print("Shutting down...")
    return
end

local success, error = pcall(bootloader)

if not success then
    print("Bootloader experienced an uncaught error.")
    print("Shutting down...")
    computer.panic(error)
else
    print("Bootloader stopped.")
    print("Shutting down...")
end