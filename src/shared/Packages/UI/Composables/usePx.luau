local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local vide = require(ReplicatedStorage.Dependencies.vide)
local source = vide.source
local callable = require(script.Parent.callable)
local useEvent = require(script.Parent.useEvent)

local BASE_RESOLUTION = Vector2.new(1280, 720)
local MIN_SCALE = 0.5
local DOMINANT_AXIS = 0.5

local scale = source(1)

local px = callable(function(value)
    return math.round(value * scale())
end, {
    even = function(value)
        return math.round(value * scale() * 0.5) * 2
    end,
    scale = function(value)
        return value * scale()
    end,
    floor = function(value)
        return math.floor(value * scale())
    end,
    ceil = function(value)
        return math.ceil(value * scale())
    end,
}) :: (number) -> number

-- Should be called once in the client.
local function usePx(once: boolean): ()
    local camera = Workspace.CurrentCamera
    local updateScale = function()
        local width = math.log(camera.ViewportSize.X / BASE_RESOLUTION.X, 2)
        local height = math.log(camera.ViewportSize.Y / BASE_RESOLUTION.Y, 2)
        local centered = width + (height - width) * DOMINANT_AXIS
        scale(math.max(2 ^ centered, MIN_SCALE))
    end

    if not once then
        useEvent(camera:GetPropertyChangedSignal("ViewportSize"), function()
            updateScale()
        end)
    end

    updateScale()
end

return {
    usePx = usePx,
    px = px,
}
