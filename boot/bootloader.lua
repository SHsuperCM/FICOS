---
--- Created by SHsuperCM.
--- DateTime: 11/08/2025 13:01
---

local os
local osMeta

for _, meta in pairs(filesystem.doFile("/boot/os.lua")) do
    if filesystem.isFile(meta.file) then
        print("Running " .. meta.name .. "(" .. meta.id .. ")..")

        loaded, err = pcall(function ()
            os = filesystem.doFile(meta.file)
            osMeta = meta
        end)

        if not loaded then
            print("Errored loading operating system file!")
            error(err)
        end

        break
    end
end

if os == nil then
    return
end

local lastStartup
while true do
    lastStartup = computer.time()
    local started, err = pcall(function()
        os:startup()
    end)

    if not started then
        print("Operating system experienced an uncaught error!")
        if err ~= nil then
            print(err)
        end
    end

    if computer.time() - lastStartup > 1 then
        print("Restarting...")
        os = filesystem.doFile(osMeta.file)
        print("Running " .. osMeta.name .. "(" .. osMeta.id .. ")..")
    else
        print("OS yielded too fast!")
        return
    end
end
