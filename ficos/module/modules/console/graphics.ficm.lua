---
--- Created by SHsuperCM.
--- DateTime: 12/08/2025 14:59
---

---@type FICModule
local module = FICModule.new("console.graphics", 1, 0, 0)

---@type number natural renderer order
module.natural = 0.0

---@type table<any, fun()> static screen rebinding tracker, gets executed when rebinding a screen
module.boundScreens = {}

---@class GraphicsRenderer
---@field order number order position of this renderer, lower runs first
GraphicsRenderer = {
    order = 0.0
}
GraphicsRenderer.__index = GraphicsRenderer

---@param gpu FINComputerGPUT2
---@param screen string
---@param width number
---@param height number
---@param graphics Graphics
function GraphicsRenderer:draw(gpu, screen, width, height, graphics)

end


---@param order number order position of this renderer, lower runs first
---@param draw fun(gpu:FINComputerGPUT2, screen:string, width:number, height:number, graphics:Graphics)
---@return GraphicsRenderer
function GraphicsRenderer.new(order, draw)
    return setmetatable({
        order = order,
        draw = draw
    }, GraphicsRenderer)
end

---@param draw fun(gpu:FINComputerGPUT2, screen:string, width:number, height:number, graphics:Graphics)
---@return GraphicsRenderer
function GraphicsRenderer.new(draw)
    module.natural = module.natural + 0.0001
    return GraphicsRenderer.new(module.natural, draw)
end

---@class Graphics
---@field activeGPU FINComputerGPUT2 Bound GPU used for rendering
---@field screens table<string, Object>
---@field renderers GraphicsRenderer[]
Graphics = {
    activeGPU = nil,
    screens = {},
    renderers = {}
}
Graphics.__index = Graphics

---@param renderer GraphicsRenderer
---@return GraphicsRenderer
function Graphics:add(renderer)
    table.insert(self.renderers, renderer)

    table.sort(self.renderers, function(a, b) return a.order < b.order end)

    return renderer
end

---@param renderer GraphicsRenderer
function Graphics:remove(renderer)
    for i, r in ipairs(self.renderers) do
        if renderer == r then
            self.renderers[i] = nil
            return
        end
    end
end

function Graphics:removeAll()
    self.renderers = {}
end

---@param gpu FINComputerGPUT2
---@return self
function Graphics:gpu(gpu)
    self.activeGPU = gpu

    return self
end

---@param name string
---@param screen any
---@return self
function Graphics:bind(name, screen)
    self.screen[name] = screen

    local prev = module.boundScreens[screen]
    if prev ~= nil then
        prev()
    end

    local graphicsRef = self -- final
    local nameInGraphics = name -- final
    module.boundScreens[screen] = function()
        graphicsRef:unbind(nameInGraphics)
    end

    return self
end

---@param name string
---@return self
function Graphics:unbind(name)
    local screen = self.screen[name]
    if screen ~= nil then
        self.screen[name] = nil
        module.boundScreens[screen] = nil
    end

    return self
end


---@return FINComputerGPUT2
function Graphics.gpuAny()
    local gpus = computer.getPCIDevices(classes.FINComputerGPUT2)
    if #gpus < 1 then
        print("No GPU available!")
        return nil
    end

    return gpus[1]
end

function Graphics.screenConsole()
    local screens = computer.getPCIDevices(classes.FINComputerScreen)
    if #screens < 1 then
        print("No Screen Driver available!")
        return nil
    end

    return screens[1]
end

return module