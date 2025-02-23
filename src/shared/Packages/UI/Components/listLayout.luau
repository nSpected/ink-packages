local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Dependencies.vide)

local create = vide.create

type Props = {
    Size: vide.Source<UDim2>,
    FillDirection: vide.Source<Enum.FillDirection>,
    HorizontalAlignment: vide.Source<Enum.HorizontalAlignment>,
    VerticalAlignment: vide.Source<Enum.VerticalAlignment>,
    ItemLineAlignment: vide.Source<Enum.ItemLineAlignment>,
    Padding: vide.Source<UDim>,
    SortOrder: vide.Source<Enum.SortOrder>,
    VerticalFlex: vide.Source<Enum.UIFlexMode>,
    HorizontalFlex: vide.Source<Enum.UIFlexMode>,
    Wraps: vide.Source<boolean>,
    Children: { any },
}

return function(props: Props)
    return create("Frame")({
        Size = props.Size or UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        create("UIListLayout")({
            FillDirection = props.FillDirection,
            HorizontalAlignment = props.HorizontalAlignment,
            VerticalAlignment = props.VerticalAlignment,
            ItemLineAlignment = props.ItemLineAlignment,
            Padding = props.Padding,
            SortOrder = props.SortOrder,
            VerticalFlex = props.VerticalFlex,
            HorizontalFlex = props.HorizontalFlex,
            Wraps = props.Wraps,
        }),
        table.unpack(props.Children),
    })
end
