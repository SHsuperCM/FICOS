---
--- Created by SHsuperCM.
--- DateTime: 12/08/2025 11:34
---

---@type FICModule
local module = FICModule.new("core.exec", 1, 0, 0)

---@param func fun()
---@return Future
function exec(func)
    local fut = async(func)

    future.addTask(fut)

    return fut
end

---@param func fun()
---@return Future
function thread(func)
    local fut = async(function()
        while true do
            func()
            coroutine.yield()
        end
    end)

    future.addTask(fut)

    return fut
end


return module