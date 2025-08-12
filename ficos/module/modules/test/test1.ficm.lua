---
--- Created by SHsuperCM.
--- DateTime: 12/08/2025 11:38
---

---@type FICModule
local module = FICModule.new("test.test1", 1, 0, 0)

import("core.exec")

thread(module, function()
    sleep(2)
    print("yippe!!!")
end)

return module