local Composables = require(script.Parent.Composables)
local lightness = 1

function GetColorTheme(colorName: string, hue: number)
    return Composables.context.FromRoot(Composables.palette.New("pallete_" .. colorName, lightness, hue))
end

type TColor = "Red" | "Orange" | "Yellow" | "Green" | "Blue" | "Cyan" | "Purple" | "LightPurple" | "Pink"

local Colors: { [TColor]: Composables.ThemeContext } = {
    Red = GetColorTheme("Red", 0.075),
    Orange = GetColorTheme("Orange", 0.150),
    Yellow = GetColorTheme("Yellow", 0.250),
    Green = GetColorTheme("Green", 0.365),
    Blue = GetColorTheme("Blue", 0.675),
    Cyan = GetColorTheme("Cyan", 0.575),
    Purple = GetColorTheme("Purple", 0.800),
    LightPurple = GetColorTheme("LightPurple", 0.860),
    Pink = GetColorTheme("Pink", 1),
}

return Colors
