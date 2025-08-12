---
--- Created by SHsuperCM.
--- DateTime: 11/08/2025 18:45
---

local runtime = {
    shouldRun = true,
    futures = { }
}

---@param module string|FICModule
---@param future Future
function runtime:add(module, future)
    if type(module) ~= "string" then
        module = module.id
    end

    self.futures[future] = module
end

---@param future Future
function runtime:remove(future)
    self.futures[future] = nil
end

---@param removalModule string|FICModule
function runtime:removeByModule(removalModule)
    if type(removalModule) ~= "string" then
        removalModule = removalModule.id
    end

    local removal = { }

    for future, module in pairs(self.futures) do
        if module == removalModule then
            removal[#removal + 1] = future
        end
    end

    for _, future in pairs(removal) do
        self:remove(future)
    end
end

function runtime:run()
    while self.shouldRun do
        local finished = { }

        for future, module in pairs(self.futures) do
            if future:poll() then
                finished[#finished + 1] = future
            end
        end

        for _, future in pairs(finished) do
            self:remove(future)
        end

        coroutine.yield()
    end
end

return runtime