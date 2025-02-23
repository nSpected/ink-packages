local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Colors = require(ReplicatedStorage.Shared.Packages.UI.Colors)
local Composables = require(ReplicatedStorage.Shared.Packages.UI.Composables)
local Vide = require(ReplicatedStorage.Dependencies.vide)
local uiLabs = require(ReplicatedStorage.Dependencies["ui-labs"])
local windowComponent = require(script.Parent.window)

local controls = {
    Size = uiLabs.EnumList(windowComponent.other.WindowSizes, "LandscapeMedium"),
    Color = uiLabs.EnumList(Colors, "Blue"),
}

return {
    vide = Vide,
    controls = controls,
    story = function(props)
        Composables.usePx(true)

        return windowComponent.render({
            Size = props.controls.Size,
            BackgroundColor = props.controls.Color().Background,
            StrokeColor = props.controls.Color().AccentOnBackground,
        })
    end,
}
