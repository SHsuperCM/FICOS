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
    os.runtime = filesystem.doFile("/ficos/runtime.lua")

    os.runtime:run()
end

return os