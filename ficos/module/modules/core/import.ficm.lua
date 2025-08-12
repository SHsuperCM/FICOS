---
--- Created by SHsuperCM.
--- DateTime: 12/08/2025 8:28
---

---@type FICModule
local module = FICModule.new("core.import", 1, 0, 0)

---@param id string id of the requested module
---@return FICModule
function import(id)
    local loadedModule
    local loaded, err = pcall(function()
        loadedModule = os.moduleManager:load(id)
    end)

    if not loaded then
        print("Could not import module " .. id)
        error(err)
    end

    return loadedModule
end

return module