---
--- Created by SHsuperCM.
--- DateTime: 11/08/2025 18:45
---

local runtime = {
    shouldRun = true,
    runRate = 0.01
}

function runtime:run()
    while self.shouldRun do
        sleep(self.runRate)
    end
end

return runtime