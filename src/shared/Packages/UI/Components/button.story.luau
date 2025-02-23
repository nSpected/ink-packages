local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Dependencies
local Colors = require(ReplicatedStorage.Shared.Packages.UI.Colors)
local Composables = require(ReplicatedStorage.Shared.Packages.UI.Composables)
local Vide = require(ReplicatedStorage.Dependencies.vide)
local uiLabs = require(ReplicatedStorage.Dependencies["ui-labs"])

-- Composables
local px = Composables.px

-- Components
local button = require(script.Parent.button)
local tooltip = require(script.Parent.tooltip)

-- Controls
local controls = {
    TextSize = 20,
    Text = "Button with long long text",
    Color = uiLabs.EnumList(Colors, "Blue"),
    HoverDelay = 1,
}

return {
    vide = Vide,
    controls = controls,
    story = function(props)
        Composables.usePx(true)

        local showTooltip = Vide.source(false)

        local hoverTask: thread? = nil
        return Vide.create("Frame")({
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = props.controls.Color().Background,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),

            button({
                Size = UDim2.fromOffset(px(200), px(100)),
                BackgroundColor3 = props.controls.Color().AccentOnBackground,
                TextColor3 = props.controls.Color().AccentOnAccentBackground,
                Text = props.controls.Text,
                TextSize = props.controls.TextSize,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Font = Enum.Font.FredokaOne,

                OnMouseEnter = function()
                    if hoverTask then
                        task.cancel(hoverTask)
                    end

                    hoverTask = task.spawn(function()
                        task.wait(props.controls.HoverDelay())
                        showTooltip(true)
                    end)
                end,

                OnMouseLeave = function()
                    if hoverTask then
                        task.cancel(hoverTask)
                    end

                    showTooltip(false)
                end,
            }),

            tooltip({
                Text = "Tooltip",
                TextSize = 22,
                TextColor3 = props.controls.Color().ForegroundOnGreyBackground,
                BackgroundColor3 = props.controls.Color().GreyOnBackground,
                BackgroundTransparency = 0.4,
                AnchorPoint = Vector2.new(0, 0),
                Position = UDim2.fromScale(0.1, 0.1),
                Visible = showTooltip,
            }),
        })
    end,
}
