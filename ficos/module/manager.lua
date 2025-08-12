---
--- Created by SHsuperCM.
--- DateTime: 11/08/2025 18:43
---

local moduleManager = {
    loaded = { }
}

---@param id string
---@return boolean true if the module is currently loaded
function moduleManager:isLoaded(id)
    return self.loaded[id:lower()] ~= nil
end

---@param id string
---@return FICModule gets or loads the requested module
function moduleManager:get(id)
    id = id:lower()

    local module = self.loaded[id]
    if module == nil then
        module = self:load(id)
    end

    return module
end

---@param id string
---@return FICModule loads the requested module, errors if fails or already loaded
function moduleManager:load(id)
    id = id:lower()

    if self:isLoaded(id) then
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
        error(err)
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

    print("Loading module " .. id)
    self.loaded[id] = module
    return module
end

---@param id string
---@return boolean true if the module was loaded before and has unloaded
function moduleManager:unload(id)
    id = id:lower()

    if not self:isLoaded(id) then
        return false
    end

    self.loaded[id]:unload()

    os.runtime:removeByModule(id)

    self.loaded[id] = nil
    print("Unloaded module " .. id)

    return true
end

function moduleManager:startup()
    filesystem.doFile("/ficos/module/FICModule.lua")

    for _, module in pairs(filesystem.doFile("/ficos/config/startupModules.lua")) do
        local loaded, err = pcall(function()
            self:load(module)
        end)

        if not loaded then
            print("Startup module " .. module .. " errored while loading.")
            if err ~= nil then
                print(err)
            end
        end
    end

    for _, module in pairs(self.loaded) do
        future.addTask(async(function()
            module:load()
        end))
    end
end

function moduleManager:shutdown()
    for id, module in pairs(self.loaded) do
        self:unload(id)
    end
end

return moduleManager