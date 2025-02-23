-- LIBRARIES --
local Oklab = require(script.oklab)

-- CONSTS --
local _LOW_CONTRAST_DISTANCE = 0.55
local HIGH_CONTRAST_DISTANCE = 0.7
local FG_SWITCH_POINT = 0.65
local MIN_Z_DEPTH = -10
local MAX_Z_DEPTH = 10

-- CONNECTIONS --
local StudioThemeChanged: RBXScriptConnection? = nil

-- TYPES --
export type ThemePalette = {
    Id: string,
    Background: { [number]: Color3 },
    ForegroundOnBackground: { [number]: Color3 },
    AccentOnBackground: { [number]: Color3 },
    GreyOnBackground: { [number]: Color3 },
    ForegroundOnAccentBackground: { [number]: Color3 },
    AccentOnAccentBackground: { [number]: Color3 },
    ForegroundOnGreyBackground: { [number]: Color3 },

    ShouldInvert: { [number]: boolean },
}

export type ThemeContext = {
    Id: string,
    Palette: ThemePalette,
    ZDepth: number,

    Background: Color3,
    ForegroundOnBackground: Color3,
    AccentOnBackground: Color3,
    GreyOnBackground: Color3,
    ForegroundOnAccentBackground: Color3,
    AccentOnAccentBackground: Color3,
    ForegroundOnGreyBackground: Color3,

    ShouldInvert: boolean,
}

local function CalculateBackgroundVector(baseLightness: number, zDepth: number)
    local lightness = baseLightness + zDepth * 0.04
    while lightness < 0 or lightness > 1 do
        if lightness > 1 then
            lightness = 1.95 - lightness
        end
        if lightness < 0 then
            lightness = 0.05 - lightness
        end
    end

    return Vector3.new(lightness, 0, 0)
end

local function ShouldInvert(backgroundVector: Vector3): boolean
    return backgroundVector.X > FG_SWITCH_POINT
end

local function CalculateForegroundVector(backgroundVector: Vector3): Vector3
    if ShouldInvert(backgroundVector) then
        return Vector3.new(math.max(0, backgroundVector.X - HIGH_CONTRAST_DISTANCE), 0, 0)
    else
        return Vector3.new(math.min(1, backgroundVector.X + HIGH_CONTRAST_DISTANCE), 0, 0)
    end
end

local function CalculateAccentVector(backgroundVector: Vector3, hue: number): Vector3
    local baseLightness = backgroundVector.X

    if baseLightness > FG_SWITCH_POINT then
        return Vector3.new(math.clamp(0.55 + (baseLightness - 0.94) / 2, 0, 1), 0.15, hue)
    else
        return Vector3.new(math.clamp(0.8 + (baseLightness - 0.24) / 2, 0, 1), 0.15, hue)
    end
end

local function CalculateGreyVector(backgroundVector: Vector3): Vector3
    local baseLightness = backgroundVector.X

    if baseLightness > FG_SWITCH_POINT then
        return Vector3.new(math.clamp(0.55 + (baseLightness - 0.94) / 2, 0, 1), 0, 0)
    else
        return Vector3.new(math.clamp(0.8 + (baseLightness - 0.24) / 2, 0, 1), 0, 0)
    end
end

local function VectorToColor3(vector: Vector3): Color3
    return Oklab.linear_srgb_to_color3(Oklab.oklab_to_linear_srgb(Oklab.oklch_to_oklab(vector)))
end

local Storage = {
    Palette = {},
    Context = {},
}

local Theme = {}

Theme.Palette = {}

-- THEME PALETTE METHODS --
function Theme.Palette.New(id: string, baseLightness: number, accentHue: number): ThemePalette
    local palette = {
        Id = id,
        Background = {},
        ForegroundOnBackground = {},
        AccentOnBackground = {},
        GreyOnBackground = {},
        ForegroundOnAccentBackground = {},
        AccentOnAccentBackground = {},
        ForegroundOnGreyBackground = {},

        ShouldInvert = {},
    }

    --// Calculate the adapted colors for the ZDepth range
    for zDepth = MIN_Z_DEPTH, MAX_Z_DEPTH do
        --// Get the color vectors
        local backgroundVector = CalculateBackgroundVector(baseLightness, zDepth)
        local foregroundOnBackgroundVector = CalculateForegroundVector(backgroundVector)
        local accentOnBackgroundVector = CalculateAccentVector(backgroundVector, accentHue)
        local greyOnBackgroundVector = CalculateGreyVector(backgroundVector)
        local foregroundOnAccentBackgroundVector = CalculateForegroundVector(accentOnBackgroundVector)
        local accentOnAccentBackgroundVector = CalculateAccentVector(accentOnBackgroundVector, accentHue)
        local foregroundOnGreyBackgroundVector = CalculateForegroundVector(greyOnBackgroundVector)
        local shouldInvert = ShouldInvert(backgroundVector)

        --// Convert the vectors into RGB colors
        palette.Background[zDepth] = VectorToColor3(backgroundVector)
        palette.ForegroundOnBackground[zDepth] = VectorToColor3(foregroundOnBackgroundVector)
        palette.AccentOnBackground[zDepth] = VectorToColor3(accentOnBackgroundVector)
        palette.GreyOnBackground[zDepth] = VectorToColor3(greyOnBackgroundVector)
        palette.ForegroundOnAccentBackground[zDepth] = VectorToColor3(foregroundOnAccentBackgroundVector)
        palette.AccentOnAccentBackground[zDepth] = VectorToColor3(accentOnAccentBackgroundVector)
        palette.ForegroundOnGreyBackground[zDepth] = VectorToColor3(foregroundOnGreyBackgroundVector)
        palette.ShouldInvert[zDepth] = shouldInvert
    end

    Storage.Palette[id] = palette
    return palette
end

type tempState<T> = {
    get: (self: tempState) -> T,
    set: (self: tempState, newValue: T) -> T,
}

function Theme.Palette.GetStudioPalette(accentHue: number?): tempState<ThemePalette>
    if Storage.Palette["Studio"] then
        return Storage.Palette["Studio"]:get()
    end

    local defaultAccentHue = 200 --// #1ba0e3
    local light = Storage.Palette["STUDIO_LIGHT"]
        or Theme.Palette.New("STUDIO_LIGHT", 0.92, accentHue or defaultAccentHue)
    local dark = Storage.Palette["STUDIO_DARK"] or Theme.Palette.New("STUDIO_DARK", 0.3, accentHue or defaultAccentHue)

    local currentPalette = light

    local function updateCurrentPalette()
        local studioBG = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
        local isDark = studioBG.R + studioBG.G + studioBG.B < 1.5

        currentPalette = (isDark and dark or light)
    end

    updateCurrentPalette()
    if StudioThemeChanged then
        StudioThemeChanged:Disconnect()
    end

    StudioThemeChanged = settings().Studio.ThemeChanged:Connect(updateCurrentPalette)

    Storage.Palette["Studio"] = currentPalette
    return Storage.Palette["Studio"]
end

function Theme.Palette.GetPalette(id: string): ThemePalette?
    return Storage.Palette[id]
end

Theme.Context = {}

-- THEME CONTEXT METHODS --
function Theme.Context.New(id: string, palette: ThemePalette, zDepth: number): ThemeContext
    if Storage.Context[id] then
        return Storage.Context[id]
    end

    local context = {
        Id = id,
        Palette = palette,
        ZDepth = zDepth,

        Background = palette.Background[zDepth],
        ForegroundOnBackground = palette.ForegroundOnBackground[zDepth],
        AccentOnBackground = palette.AccentOnBackground[zDepth],
        GreyOnBackground = palette.GreyOnBackground[zDepth],
        ForegroundOnAccentBackground = palette.ForegroundOnAccentBackground[zDepth],
        AccentOnAccentBackground = palette.AccentOnAccentBackground[zDepth],
        ForegroundOnGreyBackground = palette.ForegroundOnGreyBackground[zDepth],
        ShouldInvert = palette.ShouldInvert[zDepth],
    }

    -- Storage.Context[id] = context
    return context
end

function Theme.Context.FromRoot(palette: ThemePalette): ThemeContext
    return Theme.Context.New("Root", palette, 0)
end

function Theme.Context.WithZOffset(context: ThemeContext, zOffset: number): ThemeContext
    local id = context.Id .. "_ZOffset_" .. zOffset

    return Storage.Context[id]
        or Theme.Context.New(
            id,
            context.Palette,
            math.clamp(math.floor(context.ZDepth + zOffset), MIN_Z_DEPTH, MAX_Z_DEPTH)
        )
end

function Theme.Context.GetContext(id: string): ThemeContext?
    return Storage.Context[id]
end

return Theme :: {
    Palette: {
        New: (id: string, baseLightness: number, accentHue: number) -> ThemePalette,
        GetStudioPalette: (accentHue: number?) -> tempState<ThemePalette>,
        GetPalette: (id: string) -> ThemePalette?,
    },

    Context: {
        New: (id: string, palette: ThemePalette, zDepth: number) -> ThemeContext,
        FromRoot: (palette: ThemePalette) -> ThemeContext,
        WithZOffset: (context: ThemeContext, zOffset: number) -> ThemeContext,
        GetContext: (id: string) -> ThemeContext?,
    },
}
