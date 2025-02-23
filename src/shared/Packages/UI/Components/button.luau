local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
    Position: vide.Source<UDim2>,
    Size: vide.Source<UDim2>,
    OnActivated: (() -> ())?,
    OnMouseEnter: (() -> ())?,
    OnMouseLeave: (() -> ())?,
    TextSize: vide.Source<number>,
    BackgroundTransparency: vide.Source<number>,
    BackgroundColor3: vide.Source<Color3>,
    TextColor3: vide.Source<Color3>,
    Children: { any },
    VerticalPadding: vide.Source<UDim>,
    HorizontalPadding: vide.Source<UDim>,
    Font: vide.Source<Enum.Font>,
    Parent: Instance?,
}

return function(props: Props)
    local hovering = source(false)
    local backgroundColor = props.BackgroundColor3 or source(Color3.fromRGB(255, 255, 255))
    local textLabelSize = source(Vector2.new(0, 0))

    local verticalPadding = props.VerticalPadding or source(UDim.new(0, px(15)))
    local horizontalPadding = props.HorizontalPadding or source(UDim.new(0, px(5)))

    return create("TextButton")({
        Text = "",
        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Size = spring(function()
            local baseWidth = textLabelSize().X + horizontalPadding().Offset * 2
            local baseHeight = textLabelSize().Y + verticalPadding().Offset * 2

            if hovering() then
                baseWidth += px(10)
                baseHeight += px(10)
            end

            return UDim2.new(props.Size.X.Scale, baseWidth, props.Size.Y.Scale, baseHeight)
        end, 0.1),
        BackgroundTransparency = props.BackgroundTransparency,
        BackgroundColor3 = spring(function()
            local currentColor = backgroundColor
            if hovering() then
                currentColor = utils.GetLighterColor(currentColor, 0.1)
            end
            return currentColor
        end, 0.1),

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

            changed("AbsoluteSize", function(newSize: Vector2)
                textLabelSize(newSize)
            end),
        }),

        MouseEnter = function()
            hovering(true)
            if props.OnMouseEnter then
                props.OnMouseEnter()
            end
        end,

        MouseLeave = function()
            hovering(false)
            if props.OnMouseLeave then
                props.OnMouseLeave()
            end
        end,

        Activated = function()
            if props.OnActivated then
                props.OnActivated()
            end
        end,

        uiCorner(UDim.new(0, px(10))),
        props.Children and table.unpack(props.Children),
        Parent = props.Parent,
    })
end
