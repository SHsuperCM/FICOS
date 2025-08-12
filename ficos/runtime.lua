---
--- Created by SHsuperCM.
--- DateTime: 11/08/2025 18:45
---

local runtime = {
    shouldRun = true
}

function runtime:run()
    while self.shouldRun do
        future.run()
        coroutine.yield()
    end
end

return runtime