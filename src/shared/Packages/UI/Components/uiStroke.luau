local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Dependencies.vide)

local create = vide.create

type Props = {
    Color: vide.Source<Color3>,
    Thickness: vide.Source<number>,
}

return function(props: Props)
    return create("UIStroke")({
        Color = props.Color,
        Thickness = props.Thickness,
    })
end
