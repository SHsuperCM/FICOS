---
--- Created by SHsuperCM.
--- DateTime: 11/08/2025 14:53
---

os = {
    version = {
        major = 1,
        minor = 0,
        patch = 0
    }
}

function os:startup()
    print("~ Fic OS v" .. self.version.major .. "." .. self.version.minor .. "." .. self.version.patch .. " by SHsuperCM")

    self.runtime = filesystem.doFile("/ficos/runtime.lua")
    self.moduleManager = filesystem.doFile("/ficos/module/manager.lua")

    self.moduleManager:startup()

    self.runtime:run()
end

--- Stop the computer(allowing the bootloader to restart)
function os:stop()
    print("Stopping system...")
    self.moduleManager:shutdown()
    self.runtime.shouldRun = false
end

--- Completely shut down the computer, requires manually restarting it
function os:shutdown()
    self:stop()
    computer.stop()
end

return os