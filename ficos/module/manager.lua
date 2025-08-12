---
--- Created by SHsuperCM.
--- DateTime: 11/08/2025 18:43
---

local moduleManager = {
    loaded = { }
}

---@param id string
---@return FICModule
function moduleManager:get(id)
    id = id:lower()

    local module = self.loaded[id]
    if module == nil then
        module = self:load(id)
    end

    return module
end

---@param id string
---@return FICModule
function moduleManager:load(id)
    id = id:lower()

    if moduleManager.loaded[id] ~= nil then
        error("Module " .. id .. " is already loaded!")
    end

    local path = "/ficos/module/modules/" .. id:gsub("%.", "/") .. ".ficm.lua"
    if not filesystem.isFile(path) then
        error("No such module file '" .. path .. "'")
    end

    ---@type FICModule
    local module
    local loaded, err = pcall(function()
        module = filesystem.doFile(path)
    end)

    if not loaded then
        print("Errored loading module file for module " .. id .. "!")
        error(message)
    end

    loaded, err = pcall(function()
        if id ~= module.id:lower() then -- errors also when module is not a table or does not have an id
            error("Module id mismatch " .. id .. " <=> " .. module.id)
        end
    end)

    if not loaded then
        print("Invalid module: " .. id)
        error(err)
    end

    moduleManager.loaded[id] = module
    return module
end

---@param id string
function moduleManager:unload(id)

end

function moduleManager:startup()
    filesystem.doFile("/ficos/module/FICModule.lua")
end

function moduleManager:shutdown()
    for id, module in pairs(self.loaded) do
        self:unload(id)
    end
end

return moduleManager