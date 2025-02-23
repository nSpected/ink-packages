local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Dependencies
local Composables = require(ReplicatedStorage.Shared.Packages.UI.Composables)
local uiCorner = require(script.Parent.uiCorner)
local utils = require(ReplicatedStorage.Shared.Packages.UI.Utils)
local vide = require(ReplicatedStorage.Dependencies.vide)

-- Vide
local create = vide.create
local changed = vide.changed
local px = Composables.px
local source = vide.source
local spring = vide.spring

type Props = {
    Text: vide.Source<string>?,
    AnchorPoint: vide.Source<Vector2>,
    Size: vide.Source<UDim2>,
    TextSize: vide.Source<number>?,
    BackgroundTransparency: vide.Source<number>,
    BackgroundColor3: vide.Source<Color3>,
    TextColor3: vide.Source<Color3>,
    VerticalPadding: vide.Source<UDim>,
    HorizontalPadding: vide.Source<UDim>,
    Font: vide.Source<Enum.Font>,
    Visible: vide.Source<boolean>,
    Position: vide.Source<UDim2>,
}

return function(props: Props)
    local textLabelSize = source(Vector2.new(0, 0))

    local verticalPadding = props.VerticalPadding or source(UDim.new(0, px(15)))
    local horizontalPadding = props.HorizontalPadding or source(UDim.new(0, px(5)))

    return create("Frame")({
        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Size = spring(function()
            local baseWidth = textLabelSize().X + horizontalPadding().Offset * 2
            local baseHeight = textLabelSize().Y + verticalPadding().Offset * 2

            return UDim2.new(0, baseWidth, 0, baseHeight)
        end, 0.1),
        BackgroundColor3 = props.BackgroundColor3,
        BackgroundTransparency = spring(function()
            if props.Visible() then
                return props.BackgroundTransparency
            end

            return 1
        end, 0.3),

        create("TextLabel")({
            Text = props.Text,
            TextSize = props.TextSize,
            Font = props.Font,
            BackgroundTransparency = 1,
            TextColor3 = props.TextColor3,
            AutomaticSize = Enum.AutomaticSize.XY,
            Size = UDim2.fromScale(0, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            TextTransparency = spring(function()
                if props.Visible() then
                    return 0
                end

                return 1
            end, 0.3),

            changed("AbsoluteSize", function(newSize: Vector2)
                textLabelSize(newSize)
            end),
        }),

        uiCorner(UDim.new(0, px(10))),
        props.Children and table.unpack(props.Children),
    })
end
