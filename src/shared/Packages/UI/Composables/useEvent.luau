local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)

local function useEvent<T, C>(event: Instance, callback: (C) -> ...any)
    local connection = event:Connect(callback)
    vide.cleanup(connection)
    return connection
end

return useEvent :: <T, C>(event: Instance, callback: (C) -> ...any) -> RBXScriptConnection
