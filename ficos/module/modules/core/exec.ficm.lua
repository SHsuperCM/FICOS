---
--- Created by SHsuperCM.
--- DateTime: 12/08/2025 11:34
---

---@type FICModule
local module = FICModule.new("core.exec", 2, 0, 0)

---@param func fun()
---@return Future
function exec(mdl, func)
    local fut = async(func)

    os.runtime:add(mdl, fut)

    return fut
end

---@param func fun()
---@return Future
function thread(mdl, func)
    local fut = async(function()
        while true do
            func()
            coroutine.yield()
        end
    end)

    os.runtime:add(mdl, fut)

    return fut
end

return module