local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Composables = require(ReplicatedStorage.Shared.Packages.UI.Composables)
local vide = require(ReplicatedStorage.Dependencies.vide)

local create = vide.create

type Props = {
    CornerRadius: vide.Source<UDim>,
}

return function(radius: vide.Source<UDim>)
    return create("UICorner")({
        CornerRadius = radius,
    })
end
