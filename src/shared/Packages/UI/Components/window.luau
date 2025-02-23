local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Components
local listLayout = require(script.Parent.listLayout)
local uiCorner = require(script.Parent.uiCorner)
local uiStroke = require(script.Parent.uiStroke)
-- Dependencies
local Composables = require(ReplicatedStorage.Shared.Packages.UI.Composables)
local vide = require(ReplicatedStorage.Dependencies.vide)
local create = vide.create
local source = vide.source
local px = Composables.px

local WindowSizes = {
    LandscapeSmall = UDim2.fromOffset(px(320), px(210)),
    LandscapeMedium = UDim2.fromOffset(px(640), px(420)),
    PortraitSmall = UDim2.fromOffset(px(250), px(320)),
    PortraitMedium = UDim2.fromOffset(px(460), px(640)),
    FullScreen = UDim2.fromScale(1, 1),
}

type Props = {
    Size: vide.Source<UDim2>,
    Visible: vide.Source<boolean>,
    BackgroundColor: vide.Source<Color3>,
    StrokeColor: vide.Source<Color3>,
    Children: { any },
}

return {
    render = function(props: Props)
        local visible = props.Visible
        local size = props.Size or source(WindowSizes.LandscapeSmall)

        return create("Frame")({
            Size = size,
            Visible = visible,
            BackgroundColor3 = props.BackgroundColor,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            create("UIPadding")({
                PaddingLeft = UDim.new(0, px(5)),
                PaddingRight = UDim.new(0, px(5)),
                PaddingTop = UDim.new(0, px(5)),
                PaddingBottom = UDim.new(0, px(5)),
            }),
            uiCorner(UDim.new(0, px(10))),
            uiStroke({
                Color = props.StrokeColor,
                Thickness = px(5),
            }),
            props.Children and table.unpack(props.Children),
        })
    end,
    other = {
        WindowSizes = WindowSizes,
    },
}
