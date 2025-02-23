local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Composables = require(ReplicatedStorage.Shared.Packages.UI.Composables)

local UIUtils = {}

function UIUtils.GetDefaultLightThemeContext(hue: number): Composables.ThemeContext
    return Composables.context.FromRoot(Composables.palette.New("default", 1, hue or 0.675))
end

function UIUtils.GetDefaultDarkThemeContext(hue: number): Composables.ThemeContext
    return Composables.context.FromRoot(Composables.palette.New("default", 0, hue or 0.675))
end

function UIUtils.GetHoverLightThemeContext(hue: number): Composables.ThemeContext
    return Composables.context.New("default_hover", Composables.palette.New("default", 1, hue or 0.675), -5)
end

function UIUtils.GetHoverDarkThemeContext(hue: number): Composables.ThemeContext
    return Composables.context.New("default_hover", Composables.palette.New("default", 0, hue or 0.675), 5)
end

function UIUtils.GetDarkerColor(color: Color3, factor: number): Color3
    return color:Lerp(Color3.new(0, 0, 0), math.clamp(factor, 0, 1))
end

function UIUtils.GetLighterColor(color: Color3, factor: number): Color3
    return color:Lerp(Color3.new(1, 1, 1), math.clamp(factor, 0, 1))
end

return UIUtils
