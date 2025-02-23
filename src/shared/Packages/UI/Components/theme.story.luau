local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Composables = require(ReplicatedStorage.Shared.Packages.UI.Composables)
local Vide = require(ReplicatedStorage.Dependencies.vide)
local uiLabs = require(ReplicatedStorage.Dependencies["ui-labs"])

local create = Vide.create
local values = Vide.values
local source = Vide.source

local controls = {
    Lightness = uiLabs.Slider(1, 0, 1, 0.1),
}

return {
    vide = Vide,
    controls = controls,
    story = function(props)
        local palettesArray = {}
        for i = 0, 1.005, 0.005 do
            palettesArray[i] =
                Composables.context.FromRoot(Composables.palette.New("pallete_" .. i, props.controls.Lightness(), i))
        end

        local palettes = source(palettesArray)
        return create("ScrollingFrame")({
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            create("UIGridLayout")({
                CellSize = UDim2.fromOffset(50, 50),
                CellPadding = UDim2.fromOffset(10, 10),
                SortOrder = Enum.SortOrder.Name,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
            }),

            values(palettes, function(theme: Composables.ThemeContext, index)
                return create("TextButton")({
                    BackgroundTransparency = 0,
                    Name = string.format("%.3f", index()),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Text = "Palette " .. string.format("%.3f", index()),
                    BackgroundColor3 = theme.AccentOnBackground,
                    TextColor3 = theme.AccentOnAccentBackground,
                    TextScaled = true,
                })
            end),
        })
    end,
}
