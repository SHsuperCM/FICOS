---
--- Created by SHsuperCM.
--- DateTime: 12/08/2025 8:02
---

---@class FICModule
---@field id string
---@field version table
---@field unload fun()
FICModule = {
    id = "moduleid",
    version = {
        major = 1,
        minor = 0,
        patch = 0
    }
}

---@param id string
---@param major number version major
---@param minor number version minor
---@param patch number version patch
---@return FICModule
function FICModule.new(id, major, minor, patch)
    local module = {
        id = id,
        version = {
            major = major,
            minor = minor,
            patch = patch
        }
    }

    function module:unload()

    end

    return module
end