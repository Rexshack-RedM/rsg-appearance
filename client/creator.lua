RSGCore = exports['rsg-core']:GetCoreObject()
local isLoggedIn = false
BucketId = GetRandomIntInRange(0, 0xffffff)
ComponentsMale = {}
ComponentsFemale = {}
LoadedComponents = {}
CreatorCache = {}

MenuData = {}

TriggerEvent("rsg-menubase:getData", function(call)
    MenuData = call
end)

Firstname = nil
Lastname = nil
Nationality = nil
Selectedsex = nil
Birthdate = nil
Cid = nil

local Data = require 'data.features'
local Overlays = require 'data.overlays'
local clotheslist = require 'data.clothes_list'
local hairs_list = require 'data.hairs_list'

AddEventHandler('RSGCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = RSGCore.Functions.GetPlayerData()
end)

RegisterNetEvent('RSGCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    PlayerData = {}
end)

local MainMenus = {
    ["body"] = function()
        OpenBodyMenu()
    end,
    ["face"] = function()
        OpenFaceMenu()
    end,
    ["hair"] = function()
        OpenHairMenu()
    end,
    ["makeup"] = function()
        OpenMakeupMenu()
    end
}

local BodyFunctions = {
    ["head"] = function(target, data)
        LoadHead(target, data)
        LoadOverlays(target, data)
    end,
    ["face_width"] = function(target, data)
        LoadFeatures(target, data)
    end,
    ["skin_tone"] = function(target, data)
        LoadBoody(target, data)
        LoadOverlays(target, data)
    end,
    ["body_size"] = function(target, data)
        LoadBodyFeature(target, data.body_size, Data.Appearance.body_size)
        LoadBoody(target, data)
    end,
    ["body_waist"] = function(target, data)
        LoadBodyFeature(target, data.body_waist, Data.Appearance.body_waist)
    end,
    ["chest_size"] = function(target, data)
        LoadBodyFeature(target, data.chest_size, Data.Appearance.chest_size)
    end,
    ["height"] = function(target, data)
        LoadHeight(target, data)
    end
}

local FaceFunctions = {
    ["eyes"] = function()
        OpenEyesMenu()
    end,
    ["eyelids"] = function()
        OpenEyelidsMenu()
    end,
    ["eyebrows"] = function()
        OpenEyebrowsMenu()
    end,
    ["nose"] = function()
        OpenNoseMenu()
    end,
    ["mouth"] = function()
        OpenMouthMenu()
    end,
    ["cheekbones"] = function()
        OpenCheekbonesMenu()
    end,
    ["jaw"] = function()
        OpenJawMenu()
    end,
    ["ears"] = function()
        OpenEarsMenu()
    end,
    ["chin"] = function()
        OpenChinMenu()
    end,
    ["defects"] = function()
        OpenDefectsMenu()
    end
}

local HairFunctions = {
    ["hair"] = function(target, data)
        LoadHair(target, data)
    end,
    ["beard"] = function(target, data)
        LoadBeard(target, data)
    end
}

local EyesFunctions = {
    ["eyes_color"] = function(target, data)
        LoadEyes(target, data)
    end,
    ["eyes_depth"] = function(target, data)
        LoadFeatures(target, data)
    end,
    ["eyes_angle"] = function(target, data)
        LoadFeatures(target, data)
    end,
    ["eyes_distance"] = function(target, data)
        LoadFeatures(target, data)
    end
}

local EyelidsFunctions = {
    ["eyelid_height"] = function(target, data)
        LoadFeatures(target, data)
    end,
    ["eyelid_width"] = function(target, data)
        LoadFeatures(target, data)
    end
}

local EyebrowsFunctions = {
    ["eyebrows_t"] = function(target, data)
        LoadOverlays(target, data)
    end,
    ["eyebrows_op"] = function(target, data)
        LoadOverlays(target, data)
    end,
    ["eyebrows_id"] = function(target, data)
        LoadOverlays(target, data)
    end,
    ["eyebrows_c1"] = function(target, data)
        LoadOverlays(target, data)
    end,
    ["eyebrow_height"] = function(target, data)
        LoadFeatures(target, data)
    end,
    ["eyebrow_width"] = function(target, data)
        LoadFeatures(target, data)
    end,
    ["eyebrow_depth"] = function(target, data)
        LoadFeatures(target, data)
    end
}

CreateThread(function()
    for i, v in pairs(clotheslist) do
        if v.category_hashname == "BODIES_LOWER" or v.category_hashname == "BODIES_UPPER" or v.category_hashname ==
            "heads" or v.category_hashname == "hair" or v.category_hashname == "teeth" or v.category_hashname == "eyes" then
            if v.ped_type == "female" and v.is_multiplayer and v.hashname ~= "" then
                if ComponentsFemale[v.category_hashname] == nil then
                    ComponentsFemale[v.category_hashname] = {}
                end
                table.insert(ComponentsFemale[v.category_hashname], v.hash)
            elseif v.ped_type == "male" and v.is_multiplayer and v.hashname ~= "" then
                if ComponentsMale[v.category_hashname] == nil then
                    ComponentsMale[v.category_hashname] = {}
                end
                table.insert(ComponentsMale[v.category_hashname], v.hash)
            end
        end
    end
    if not IsImapActive(183712523) then
        RequestImap(183712523) -- CharacterCreator
    end
    if not IsImapActive(-1699673416) then
        RequestImap(-1699673416) -- CharacterCreator
    end
    if not IsImapActive(1679934574) then
        RequestImap(1679934574) -- CharacterCreator
    end
end)

function ApplySkin()
    local _Target = PlayerPedId()
    local citizenid = RSGCore.Functions.GetPlayerData().citizenid
    local currentHealth = LocalPlayer.state.health or GetEntityHealth(_Target)
    local dirtClothes = GetAttributeBaseRank(_Target, 16)
    local dirtHat = GetAttributeBaseRank(_Target, 17)
    local dirtSkin = GetAttributeBaseRank(_Target, 22)

    local promise = promise.new()
    RSGCore.Functions.TriggerCallback('rsg-multicharacter:server:getAppearance', function(data)
        local _SkinData = data.skin
        local _Clothes = data.clothes
        if _Target == PlayerPedId() then
            local model = GetPedModel(tonumber(_SkinData.sex))
            LoadModel(PlayerPedId(), model)
            _Target = PlayerPedId()
            SetEntityAlpha(_Target, 0)
            LoadedComponents = _SkinData
        end
        FixIssues(_Target)
        LoadHeight(_Target, _SkinData)
        LoadBoody(_Target, _SkinData)
        LoadHead(_Target, _SkinData)
        LoadHair(_Target, _SkinData)
        LoadBeard(_Target, _SkinData)
        LoadEyes(_Target, _SkinData)
        LoadFeatures(_Target, _SkinData)
        LoadBodyFeature(_Target, _SkinData.body_size, Data.Appearance.body_size)
        LoadBodyFeature(_Target, _SkinData.body_waist, Data.Appearance.body_waist)
        LoadBodyFeature(_Target, _SkinData.chest_size, Data.Appearance.chest_size)
        LoadOverlays(_Target, _SkinData)
        SetEntityAlpha(_Target, 255)
        SetAttributeCoreValue(_Target, 0, 100)
        SetAttributeCoreValue(_Target, 1, 100)
        SetEntityHealth(_Target, currentHealth, 0)
        Citizen.InvokeNative(0x8899C244EBCF70DE, PlayerId(), 0.0)
        Citizen.InvokeNative(0xDE1B1907A83A1550, _Target, 0)
        if _Target == PlayerPedId() then
            TriggerEvent('rsg-appearance:client:ApplyClothes', _Clothes, _Target, _SkinData)
        else
            for i, m in pairs(Overlays.overlay_all_layers) do
                Overlays.overlay_all_layers[i] =
                { name = m.name, visibility = 0, tx_id = 1, tx_normal = 0, tx_material = 0, tx_color_type = 0, tx_opacity = 1.0, tx_unk = 0, palette = 0, palette_color_primary = 0, palette_color_secondary = 0, palette_color_tertiary = 0, var = 0, opacity = 0.0 }
            end
        end
        SetAttributeBaseRank(_Target, 16, dirtClothes)
        SetAttributeBaseRank(_Target, 17, dirtHat)
        SetAttributeBaseRank(_Target, 22, dirtSkin)
        promise:resolve()
    end, citizenid)
    Citizen.Await(promise)
end

local function ApplySkinMultiChar(SkinData, Target, ClothesData)
    FixIssues(Target)
    LoadHeight(Target, SkinData)
    LoadBoody(Target, SkinData)
    LoadHead(Target, SkinData)
    LoadHair(Target, SkinData)
    LoadBeard(Target, SkinData)
    LoadEyes(Target, SkinData)
    LoadFeatures(Target, SkinData)
    LoadBodyFeature(Target, SkinData.body_size, Data.Appearance.body_size)
    LoadBodyFeature(Target, SkinData.body_waist, Data.Appearance.body_waist)
    LoadBodyFeature(Target, SkinData.chest_size, Data.Appearance.chest_size)
    LoadOverlays(Target, SkinData)
    TriggerEvent('rsg-appearance:client:ApplyClothes', ClothesData, Target, SkinData)
end

exports('ApplySkinMultiChar', ApplySkinMultiChar)

RegisterNetEvent('rsg-appearance:client:OpenCreator', function(data, empty)
    if data then
        Cid = data.cid
    elseif empty then
        Skinkosong = true
    end

    StartCreator()

end)

RegisterCommand('loadskin', function(source, args, raw)
    if LocalPlayer.state.invincible then return end
    LocalPlayer.state.invincible = true

    local ped = PlayerPedId()
    local isdead = IsEntityDead(ped)
    local cuffed = IsPedCuffed(ped)
    local hogtied = Citizen.InvokeNative(0x3AA24CCC0D451379, ped)
    local lassoed = Citizen.InvokeNative(0x9682F850056C9ADE, ped)
    local dragged = Citizen.InvokeNative(0xEF3A8772F085B4AA, ped)
    local ragdoll = IsPedRagdoll(ped)
    local falling = IsPedFalling(ped)
    local isJailed = 0

    RSGCore.Functions.GetPlayerData(function(player)
        isJailed = player.metadata["injail"]
    end)

    if isdead or cuffed or hogtied or lassoed or dragged or ragdoll or falling or isJailed > 0 then
        LocalPlayer.state.invincible = false
        return
    end

    ApplySkin()
    
    LocalPlayer.state.invincible = false
end, false)

local function checkStrings(input)
    if RSG.ProfanityWords[input:lower()] then return false end
    if not string.match(input, '%u%l*') then
        lib.notify({ title = locale('invalid_character_name.title'), description = locale('invalid_character_name.description'), type = 'error', duration = 7000 })
        return false
    end
    return true
end

function StartCreator()
    TriggerServerEvent('rsg-appearance:server:SetPlayerBucket' , BucketId)
    Wait(1)
    for i, m in pairs(Overlays.overlay_all_layers) do
        Overlays.overlay_all_layers[i] =
        {name = m.name, visibility = 0, tx_id = 1, tx_normal = 0, tx_material = 0, tx_color_type = 0, tx_opacity = 1.0, tx_unk = 0, palette = 0, palette_color_primary = 0, palette_color_secondary = 0, palette_color_tertiary = 0, var = 0, opacity = 0.0}
    end
    MenuData.CloseAll()
    SpawnPeds()
end

function FirstMenu()
    MenuData.CloseAll()

    local elements = {}

    if Skinkosong then
        Labelsave = RSG.Texts.firsmenu.Start
        Valuesave = 'save'
    end

    if (IsInCharCreation or Skinkosong) then
        elements[#elements + 1] = {
            label = locale('creator.appearance.label'),
            value = "appearance",
            desc = locale('creator.appearance.desc'),
        }
        elements[#elements + 1] = {
            label = locale('creator.clothing.label'),
            value = "clothes",
            desc = locale('creator.clothing.desc'),
        }
    end

    if IsInCharCreation and not Skinkosong then
        elements[#elements + 1] = {
            label = Firstname or RSG.Texts.firsmenu.label_firstname .. "<br><span style='opacity:0.6;'>" .. RSG.Texts.firsmenu.none .. "</span>",
            value = "firstname",
            desc = locale('creator.firstname.desc'),
        }
        elements[#elements + 1] = {
            label = Lastname or
                RSG.Texts.firsmenu.label_lastname ..
                "<br><span style='opacity:0.6;'>" .. "" .. RSG.Texts.firsmenu.none .. "" .. "</span>",
            value = "lastname",
            desc = locale('creator.lastname.desc')
        }
        elements[#elements + 1] = {
            label = Nationality or
                RSG.Texts.firsmenu.Nationality ..
                "<br><span style='opacity:0.6;'>" .. "" .. RSG.Texts.firsmenu.none .. "" .. "</span>",
            value = "nationality",
            desc = locale('creator.nationality.desc')

        }

        elements[#elements + 1] = {
            label = Birthdate or
                RSG.Texts.firsmenu.Birthdate ..
                "<br><span style='opacity:0.6;'>" .. "" .. RSG.Texts.firsmenu.none .. "" .. "</span>",
            value = "birthdate",
            desc = locale('creator.birthdate.desc')
        }
    end

    elements[#elements + 1] = {
        label = Labelsave or ("<span style='color: Grey;'>" .. RSG.Texts.firsmenu.Start .. "<br>" .. RSG.Texts.firsmenu.empty .. "" .. "</span>"),
        value = Valuesave or 'not',
        desc = ""
    }
    MenuData.Open('default', GetCurrentResourceName(), 'FirstMenu',
        {
            title = RSG.Texts.Creator,
            subtext = RSG.Texts.Options,
            align = RSG.Texts.align,
            elements = elements,
            itemHeight = "4vh"
        }, function(data, menu)
            if (data.current.value == 'appearance') then
                return MainMenu()
            end

            if (data.current.value == 'clothes') then
                return OpenClothingMenu()
            end

            if (data.current.value == 'firstname') then

                :: noMatch ::

                local dialog = lib.inputDialog(locale('creator.firstname.input.header'), {
                    {
                        type = 'input',
                        required = true,
                        icon = 'user-pen',
                        label = locale('creator.firstname.input.label'),
                        placeholder = locale('creator.firstname.input.placeholder')
                    },
                })
                if not dialog then return false end
                local firstName = dialog[1]
                if not checkStrings(firstName) then
                    goto noMatch
                end

                Firstname = firstName
                menu.setElement(3, "label", Firstname)
                menu.setElement(3, "itemHeight", "4vh")
                menu.refresh()
            end
            if (data.current.value == 'lastname') then

                :: noMatch ::

                local dialog = lib.inputDialog(locale('creator.lastname.input.header'), {
                    {
                        type = 'input',
                        required = true,
                        icon = 'user-pen',
                        label = locale('creator.lastname.input.label'),
                        placeholder = locale('creator.lastname.input.placeholder')
                    },
                })
                if not dialog then return false end
                local lastname = dialog[1]
                if not checkStrings(lastname) then
                    goto noMatch
                end
                Lastname = lastname
                menu.setElement(4, "label", Lastname)
                menu.setElement(4, "itemHeight", "4vh")
                menu.refresh()
            end

            if (data.current.value == 'nationality') then

                :: noMatch ::

                local dialog = lib.inputDialog(locale('creator.nationality.input.header'), {
                    {
                        type = 'input',
                        required = true,
                        icon = 'user-shield',
                        label = locale('creator.nationality.input.label'),
                        placeholder = locale('creator.nationality.input.placeholder')
                    },
                })
                if not dialog then return false end
                local national = dialog[1]
                if not checkStrings(national) then
                    goto noMatch
                end
                Nationality = national
                menu.setElement(5, "label", Nationality)
                menu.setElement(5, "itemHeight", "4vh")
                menu.refresh()
            end

            if (data.current.value == 'birthdate') then

                local dialog = lib.inputDialog(locale('creator.birthdate.input.header'), {
                    {
                        type = 'date',
                        required = true,
                        icon = 'calendar-days',
                        label = locale('creator.birthdate.input.label'),
                        format = 'YYYY-MM-DD',
                        returnString = true,
                        min = '1750-01-01', -- Has to be in the same in the same format as the format argument
                        max = '1900-01-01', -- Has to be in the same in the same format as the format argument
                        default = '1870-01-01'
                    }
                })
                if not dialog then return false end
                Birthdate = dialog[1]
                Labelsave = RSG.Texts.firsmenu.Start
                Valuesave = 'save'
                menu.setElement(6, "label", Birthdate)
                menu.setElement(6, "itemHeight", "4vh")
                menu.removeElementByIndex(7)
                menu.addNewElement({
                    label = RSG.Texts.firsmenu.Start,
                    value = Valuesave,
                    desc = ""
                })
                menu.refresh()
            end
            if data.current.value == 'save' then
                LoadedComponents = CreatorCache
                if Skinkosong then
                    MenuData.CloseAll()
                    Skinkosong = false
                    Firstname = RSGCore.Functions.GetPlayerData().charinfo.firstname
                    Lastname = RSGCore.Functions.GetPlayerData().charinfo.lastname
                    FotoMugshots()
                elseif Firstname and Lastname and Nationality and Selectedsex and Birthdate and Cid then
                    MenuData.CloseAll()
                    local newData = {
                        firstname = Firstname,
                        lastname = Lastname,
                        nationality = Nationality,
                        gender = Selectedsex == 1 and 0 or 1,
                        birthdate = Birthdate,
                        cid = Cid
                    }
                    TriggerServerEvent('rsg-multicharacter:server:createCharacter', newData)
                    Wait(500)
                    FotoMugshots()
                else
                    lib.notify({ title = locale('missing_character_info.title'), description = locale('missing_character_info.description'), type = 'error', duration = 7000 })
                end
            end
        end, function(data, menu)
        end)
end

function MainMenu()
    MenuData.CloseAll()
    local elements = {
        {label = RSG.Texts.Body,       value = 'body',   desc = ""},
        {label = RSG.Texts.Face,       value = 'face',   desc = ""},
        {label = RSG.Texts.Hair_beard, value = 'hair',   desc = ""},
        {label = RSG.Texts.Makeup,     value = 'makeup', desc = ""},
    }
    MenuData.Open('default', GetCurrentResourceName(), 'main_character_creator_menu',
        {title = RSG.Texts.Appearance, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
        MainMenus[data.current.value]()
    end, function(data, menu)
        FirstMenu()
    end)
end

function OpenBodyMenu()
    MenuData.CloseAll()
    local elements = {
        { label = RSG.Texts.Face,     value = CreatorCache["head"] or 1,       category = "head",       desc = "", type = "slider", min = 1,    max = 120,                         hop = 6 },
        { label = RSG.Texts.Width,    value = CreatorCache["face_width"] or 0, category = "face_width", desc = "", type = "slider", min = -100, max = 100,                         hop = 5 },
        { label = RSG.Texts.SkinTone, value = CreatorCache["skin_tone"] or 1,  category = "skin_tone",  desc = "", type = "slider", min = 1,    max = 6 },
        { label = RSG.Texts.Size,     value = CreatorCache["body_size"] or 1,  category = "body_size",  desc = "", type = "slider", min = 1,    max = #Data.Appearance.body_size },
        { label = RSG.Texts.Waist,    value = CreatorCache["body_waist"] or 1, category = "body_waist", desc = "", type = "slider", min = 1,    max = #Data.Appearance.body_waist },
        { label = RSG.Texts.Chest,    value = CreatorCache["chest_size"] or 1, category = "chest_size", desc = "", type = "slider", min = 1,    max = #Data.Appearance.chest_size },
        { label = RSG.Texts.Height,   value = CreatorCache["height"] or 100,   category = "height",     desc = "", type = "slider", min = 95,   max = 105 }
    }
    MenuData.Open('default', GetCurrentResourceName(), 'body_character_creator_menu',
        {title = RSG.Texts.Appearance, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
    end, function(data, menu)
        MainMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            BodyFunctions[data.current.category](PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenFaceMenu()
    MenuData.CloseAll()
    local elements = {
        {label = RSG.Texts.Eyes,       value = 'eyes',       desc = ""},
        {label = RSG.Texts.Eyelids,    value = 'eyelids',    desc = ""},
        {label = RSG.Texts.Eyebrows,   value = 'eyebrows',   desc = ""},
        {label = RSG.Texts.Nose,       value = 'nose',       desc = ""},
        {label = RSG.Texts.Mouth,      value = 'mouth',      desc = ""},
        {label = RSG.Texts.Cheekbones, value = 'cheekbones', desc = ""},
        {label = RSG.Texts.Jaw,        value = 'jaw',        desc = ""},
        {label = RSG.Texts.Ears,       value = 'ears',       desc = ""},
        {label = RSG.Texts.Chin,       value = 'chin',       desc = ""},
        {label = RSG.Texts.Defects,    value = 'defects',    desc = ""}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'face_main_character_creator_menu',
        {title = RSG.Texts.Face, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
        FaceFunctions[data.current.value]()
    end, function(data, menu)
        MainMenu()
    end)
end

function OpenHairMenu()
    MenuData.CloseAll()
    local elements = {}
    if IsPedMale(PlayerPedId()) then
        local a = 1
        if CreatorCache["hair"] == nil or type(CreatorCache["hair"]) ~= "table" then
            CreatorCache["hair"] = {}
            CreatorCache["hair"].model = 0
            CreatorCache["hair"].texture = 1
        end
        if CreatorCache["beard"] == nil or type(CreatorCache["beard"]) ~= "table" then
            CreatorCache["beard"] = {}
            CreatorCache["beard"].model = 0
            CreatorCache["beard"].texture = 1
        end
        elements[#elements + 1] = {
            label = RSG.Texts.HairStyle,
            value = CreatorCache["hair"].model or 0,
            category = "hair",
            desc = "",
            type = "slider",
            min = 0,
            max = #hairs_list["male"]["hair"],
            change_type = "model",
            id = a,
        }
        a = a + 1
        elements[#elements + 1] = {
            label = RSG.Texts.HairColor,
            value = CreatorCache["hair"].texture or 1,
            category = "hair",
            desc = "",
            type = "slider",
            min = 1,
            max = GetMaxTexturesForModel("hair", CreatorCache["hair"].model or 1, false),
            change_type = "texture",
            id = a,
        }
        a = a + 1
        elements[#elements + 1] = {
            label = RSG.Texts.BeardStyle,
            value = CreatorCache["beard"].model or 0,
            category = "beard",
            desc = "",
            type = "slider",
            min = 0,
            max = #hairs_list["male"]["beard"],
            change_type = "model",
            id = a,
        }
        a = a + 1
        elements[#elements + 1] = {
            label = RSG.Texts.BeardColor,
            value = CreatorCache["beard"].texture or 1,
            category = "beard",
            desc = "",
            type = "slider",
            min = 1,
            max = GetMaxTexturesForModel("beard", CreatorCache["beard"].model or 1, false),
            change_type = "texture",
            id = a,
        }
        a = a + 1
    else
        local a = 1
        if CreatorCache["hair"] == nil or type(CreatorCache["hair"]) ~= "table" then
            CreatorCache["hair"] = {}
            CreatorCache["hair"].model = 0
            CreatorCache["hair"].texture = 1
        end
        elements[#elements + 1] = {
            label = RSG.Texts.Hair,
            value = CreatorCache["hair"].model or 0,
            category = "hair",
            desc = "",
            type = "slider",
            min = 0,
            max = #hairs_list["female"]["hair"],
            change_type = "model",
            id = a,
        }
        a = a + 1
        elements[#elements + 1] = {
            label = RSG.Texts.HairColor,
            value = CreatorCache["hair"].texture or 1,
            category = "hair",
            desc = "",
            type = "slider",
            min = 1,
            max = GetMaxTexturesForModel("hair", CreatorCache["hair"].model or 1),
            change_type = "texture",
            id = a,
        }
        a = a + 1
    end
    MenuData.Open('default', GetCurrentResourceName(), 'hair_main_character_creator_menu',
        {title = RSG.Texts.Hair_beard, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
    end, function(data, menu)
        MainMenu()
    end, function(data, menu)
        if data.current.change_type == "model" then
            if CreatorCache[data.current.category].model ~= data.current.value then
                CreatorCache[data.current.category].texture = 1
                CreatorCache[data.current.category].model = data.current.value
                if data.current.value > 0 then
                    menu.setElement(data.current.id + 1, "max", GetMaxTexturesForModel(data.current.category, data.current.value, false))
                    menu.setElement(data.current.id + 1, "min", 1)
                    menu.setElement(data.current.id + 1, "value", 1)
                    menu.refresh()
                else
                    menu.setElement(data.current.id + 1, "max", 0)
                    menu.setElement(data.current.id + 1, "min", 0)
                    menu.setElement(data.current.id + 1, "value", 0)
                    menu.refresh()
                end
                HairFunctions[data.current.category](PlayerPedId(), CreatorCache)
            end
         elseif data.current.change_type == "texture" then
            if CreatorCache[data.current.category].texture ~= data.current.value then
                CreatorCache[data.current.category].texture = data.current.value
                HairFunctions[data.current.category](PlayerPedId(), CreatorCache)
            end
        else
            if CreatorCache[data.current.category] ~= data.current.value then
                CreatorCache[data.current.category] = data.current.value
                HairFunctions[data.current.category](PlayerPedId(), CreatorCache)
            end
        end
    end)
end

function OpenEyesMenu()
    MenuData.CloseAll()
    local EyesColorOptions = {RSG.Texts.EyesTone1,RSG.Texts.EyesTone2,RSG.Texts.EyesTone3,RSG.Texts.EyesTone4,RSG.Texts.EyesTone5,RSG.Texts.EyesTone5}
    local elements = {
        {label = RSG.Texts.Color,    value = CreatorCache["eyes_color"] or 1,    category = "eyes_color",    desc = "", type = "slider", min = 1,max = 18},
        {label = RSG.Texts.Depth,    value = CreatorCache["eyes_depth"] or 0,    category = "eyes_depth",    desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Angle,    value = CreatorCache["eyes_angle"] or 0,    category = "eyes_angle",    desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Distance, value = CreatorCache["eyes_distance"] or 0, category = "eyes_distance", desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'eyes_character_creator_menu',
    {title = RSG.Texts.Eyes, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            EyesFunctions[data.current.category](PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenEyelidsMenu()
    MenuData.CloseAll()
    local elements = {
        {label = RSG.Texts.Height, value = CreatorCache["eyelid_height"] or 0, category = "eyelid_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Width,  value = CreatorCache["eyelid_width"] or 0,  category = "eyelid_width",  desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'eyelid_character_creator_menu',
        {title = RSG.Texts.Eyelids, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            EyelidsFunctions[data.current.category](PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenEyebrowsMenu()
    MenuData.CloseAll()
    local elements = {
        {label = RSG.Texts.Height,         value = CreatorCache["eyebrow_height"] or 0, category = "eyebrow_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Width,          value = CreatorCache["eyebrow_width"] or 0,  category = "eyebrow_width",  desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Depth,          value = CreatorCache["eyebrow_depth"] or 0,  category = "eyebrow_depth",  desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Type,           value = CreatorCache["eyebrows_t"] or 1,     category = "eyebrows_t",     desc = "", type = "slider", min = 1, max = 15},
        {label = RSG.Texts.Visibility,     value = CreatorCache["eyebrows_op"] or 100,  category = "eyebrows_op",    desc = "", type = "slider", min = 0, max = 100,    hop = 5},
        {label = RSG.Texts.ColorPalette,   value = CreatorCache["eyebrows_id"] or 10,   category = "eyebrows_id",    desc = "", type = "slider", min = 1, max = 25},
        {label = RSG.Texts.ColorFirstrate, value = CreatorCache["eyebrows_c1"] or 0,    category = "eyebrows_c1",    desc = "", type = "slider", min = 0, max = 64}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'eyebrows_character_creator_menu',
        {title = RSG.Texts.Eyebrows, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            EyebrowsFunctions[data.current.category](PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenNoseMenu()
    MenuData.CloseAll()
    local elements = {
        {label = RSG.Texts.Width,         value = CreatorCache["nose_width"] or 0,        category = "nose_width",        desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Size,          value = CreatorCache["nose_size"] or 0,         category = "nose_size",         desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Height,        value = CreatorCache["nose_height"] or 0,       category = "nose_height",       desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Angle,         value = CreatorCache["nose_angle"] or 0,        category = "nose_angle",        desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.NoseCurvature, value = CreatorCache["nose_curvature"] or 0,    category = "nose_curvature",    desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Distance,      value = CreatorCache["nostrils_distance"] or 0, category = "nostrils_distance", desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'nose_character_creator_menu',
        {title = RSG.Texts.Nose, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadFeatures(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenMouthMenu()
    MenuData.CloseAll()

    RequestAnimDict("FACE_HUMAN@GEN_MALE@BASE")

    while not HasAnimDictLoaded("FACE_HUMAN@GEN_MALE@BASE") do
        Wait(100)
    end

    TaskPlayAnim(PlayerPedId(), "FACE_HUMAN@GEN_MALE@BASE", "Face_Dentistry_Loop", 1090519040, -4, -1, 17, 0, 0, 0, 0, 0, 0)

    local elements = {
        {label = RSG.Texts.Teeth,          value = CreatorCache["teeth"] or 1,      category = "teeth",      desc = "", type = "slider", min = 1, max = 7},
        {label = RSG.Texts.Width,          value = CreatorCache["mouth_width"] or 0,      category = "mouth_width",      desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Depth,          value = CreatorCache["mouth_depth"] or 0,      category = "mouth_depth",      desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.UP_DOWN,        value = CreatorCache["mouth_x_pos"] or 0,      category = "mouth_x_pos",      desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.left_right,     value = CreatorCache["mouth_y_pos"] or 0,      category = "mouth_y_pos",      desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.UpperLipHeight, value = CreatorCache["upper_lip_height"] or 0, category = "upper_lip_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.UpperLipWidth,  value = CreatorCache["upper_lip_width"] or 0,  category = "upper_lip_width",  desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.UpperLipDepth,  value = CreatorCache["upper_lip_depth"] or 0,  category = "upper_lip_depth",  desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.LowerLipHeight, value = CreatorCache["lower_lip_height"] or 0, category = "lower_lip_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.LowerLipWidth,  value = CreatorCache["lower_lip_width"] or 0,  category = "lower_lip_width",  desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.LowerLipDepth,  value = CreatorCache["lower_lip_depth"] or 0,  category = "lower_lip_depth",  desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'mouth_character_creator_menu',
        {title = RSG.Texts.Mouth, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
    end, function(data, menu)
        ClearPedTasks(PlayerPedId())
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadFeatures(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenCheekbonesMenu()
    MenuData.CloseAll()
    local elements = {
        {label = RSG.Texts.Height, value = CreatorCache["cheekbones_height"] or 0, category = "cheekbones_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Width,  value = CreatorCache["cheekbones_width"] or 0,  category = "cheekbones_width",  desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Depth,  value = CreatorCache["cheekbones_depth"] or 0,  category = "cheekbones_depth",  desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'cheekbones_character_creator_menu',
        {title = 'Cheek Bones', subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadFeatures(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenJawMenu()
    MenuData.CloseAll()
    local elements = {
        {label = RSG.Texts.Height, value = CreatorCache["jaw_height"] or 0, category = "jaw_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Width,  value = CreatorCache["jaw_width"] or 0,  category = "jaw_width",  desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Depth,  value = CreatorCache["jaw_depth"] or 0,  category = "jaw_depth",  desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'jaw_character_creator_menu',
        {title = RSG.Texts.Jaw, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadFeatures(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenEarsMenu()
    MenuData.CloseAll()
    local elements = {
        {label = RSG.Texts.Width,  value = CreatorCache["ears_width"] or 0,   category = "ears_width",   desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Angle,  value = CreatorCache["ears_angle"] or 0,   category = "ears_angle",   desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Height, value = CreatorCache["ears_height"] or 0,  category = "ears_height",  desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Size,   value = CreatorCache["earlobe_size"] or 0, category = "earlobe_size", desc = "", type = "slider", min = -100, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'ears_character_creator_menu',
        {title = RSG.Texts.Ears, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadFeatures(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenChinMenu()
    MenuData.CloseAll()
    local elements = {
        {label = RSG.Texts.Size, value = CreatorCache["chin_height"] or 0, category = "chin_height", desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Size, value = CreatorCache["chin_width"] or 0,  category = "chin_width",  desc = "", type = "slider", min = -100, max = 100, hop = 5},
        {label = RSG.Texts.Size, value = CreatorCache["chin_depth"] or 0,  category = "chin_depth",  desc = "", type = "slider", min = -100, max = 100, hop = 5}}
    MenuData.Open('default', GetCurrentResourceName(), 'chin_character_creator_menu',
        {title = RSG.Texts.Chin, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadFeatures(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenDefectsMenu()
    MenuData.CloseAll()
    local elements = {
        {label = RSG.Texts.Scars,    value = CreatorCache["scars_t"] or 1,     category = "scars_t",     desc = "", type = "slider", min = 1, max = 16,  options = nil},
        {label = RSG.Texts.Clarity,  value = CreatorCache["scars_op"] or 50,    category = "scars_op",    desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = RSG.Texts.Older,    value = CreatorCache["ageing_t"] or 1,    category = "ageing_t",    desc = "", type = "slider", min = 1, max = 24,  options = nil},
        {label = RSG.Texts.Clarity,  value = CreatorCache["ageing_op"] or 50,   category = "ageing_op",   desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = RSG.Texts.Freckles, value = CreatorCache["freckles_t"] or 1,  category = "freckles_t",  desc = "", type = "slider", min = 1, max = 15,  options = nil},
        {label = RSG.Texts.Clarity,  value = CreatorCache["freckles_op"] or 50, category = "freckles_op", desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = RSG.Texts.Moles,    value = CreatorCache["moles_t"] or 1,     category = "moles_t",     desc = "", type = "slider", min = 1, max = 16,  options = nil},
        {label = RSG.Texts.Clarity,  value = CreatorCache["moles_op"] or 50,    category = "moles_op",    desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = RSG.Texts.Spots,    value = CreatorCache["spots_t"] or 1,     category = "spots_t",     desc = "", type = "slider", min = 1, max = 16,  options = nil},
        {label = RSG.Texts.Clarity,  value = CreatorCache["spots_op"] or 50,    category = "spots_op",    desc = "", type = "slider", min = 0, max = 100, hop = 5}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'defects_character_creator_menu',
        {title = RSG.Texts.Disadvantages, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
    end, function(data, menu)
        OpenFaceMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadOverlays(PlayerPedId(), CreatorCache)
        end
    end)
end

function OpenMakeupMenu()
    MenuData.CloseAll()
    local elements = {
        {label = RSG.Texts.Shadow,           value = CreatorCache["shadows_t"] or 1,    category = "shadows_t",    desc = "", type = "slider", min = 1, max = 5},
        {label = RSG.Texts.Clarity,          value = CreatorCache["shadows_op"] or 0,   category = "shadows_op",   desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = RSG.Texts.ColorShadow,      value = CreatorCache["shadows_id"] or 1,   category = "shadows_id",   desc = "", type = "slider", min = 1, max = 25},
        {label = RSG.Texts.ColorFirst_Class, value = CreatorCache["shadows_c1"] or 0,   category = "shadows_c1",   desc = "", type = "slider", min = 0, max = 64},
        {label = RSG.Texts.Blushing_Cheek,   value = CreatorCache["blush_t"] or 1,      category = "blush_t",      desc = "", type = "slider", min = 1, max = 4},
        {label = RSG.Texts.Clarity,          value = CreatorCache["blush_op"] or 0,     category = "blush_op",     desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = RSG.Texts.blush_id,         value = CreatorCache["blush_id"] or 1,     category = "blush_id",     desc = "", type = "slider", min = 1, max = 25},
        {label = RSG.Texts.blush_c1,         value = CreatorCache["blush_c1"] or 0,     category = "blush_c1",     desc = "", type = "slider", min = 0, max = 64},
        {label = RSG.Texts.Lipstick,         value = CreatorCache["lipsticks_t"] or 1,  category = "lipsticks_t",  desc = "", type = "slider", min = 1, max = 7},
        {label = RSG.Texts.Clarity,          value = CreatorCache["lipsticks_op"] or 0, category = "lipsticks_op", desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = RSG.Texts.ColorLipstick,    value = CreatorCache["lipsticks_id"] or 1, category = "lipsticks_id", desc = "", type = "slider", min = 1, max = 25},
        {label = RSG.Texts.lipsticks_c1,     value = CreatorCache["lipsticks_c1"] or 0, category = "lipsticks_c1", desc = "", type = "slider", min = 0, max = 64},
        {label = RSG.Texts.lipsticks_c2,     value = CreatorCache["lipsticks_c2"] or 0, category = "lipsticks_c2", desc = "", type = "slider", min = 0, max = 64},
        {label = RSG.Texts.Eyeliners,        value = CreatorCache["eyeliners_t"] or 1,  category = "eyeliners_t",  desc = "", type = "slider", min = 1, max = 15},
        {label = RSG.Texts.Clarity,          value = CreatorCache["eyeliners_op"] or 0, category = "eyeliners_op", desc = "", type = "slider", min = 0, max = 100, hop = 5},
        {label = RSG.Texts.eyeliners_id,     value = CreatorCache["eyeliners_id"] or 1, category = "eyeliners_id", desc = "", type = "slider", min = 1, max = 25},
        {label = RSG.Texts.eyeliners_c1,     value = CreatorCache["eyeliners_c1"] or 0, category = "eyeliners_c1", desc = "", type = "slider", min = 0, max = 64}
    }
    MenuData.Open('default', GetCurrentResourceName(), 'makeup_character_creator_menu',
        {title = RSG.Texts.Make_up, subtext = RSG.Texts.Options, align = RSG.Texts.align, elements = elements, itemHeight = "4vh"}, function(data, menu)
    end, function(data, menu)
        MainMenu()
    end, function(data, menu)
        if CreatorCache[data.current.category] ~= data.current.value then
            CreatorCache[data.current.category] = data.current.value
            LoadOverlays(PlayerPedId(), CreatorCache)
        end
    end)
end

exports('GetComponentId', function(name)
    return LoadedComponents[name]
end)

exports('GetBodyComponents', function()
    return {ComponentsMale, ComponentsFemale}
end)

exports('GetBodyCurrentComponentHash', function(name)
    local hash
    if name == "hair" or name == "beard" then
        local info = LoadedComponents[name]

        if not info then return end

        local texture = info.texture
        local model = info.model
        if model == 0 or texture == 0 then
            return
        end
        if type(info) == "table" then
            if IsPedMale(PlayerPedId()) then
                if hairs_list["male"][name][model][texture] ~= nil then
                    hash = hairs_list["male"][name][model][texture].hash
                end
            else
                if hairs_list["female"][name][model][texture] ~= nil then
                    hash = hairs_list["female"][name][model][texture].hash
                end
            end
        end
    else
        local id = LoadedComponents[name]
        if not id then
            return
        end
        if IsPedMale(PlayerPedId()) then
            if ComponentsMale[name] ~= nil then
                hash = ComponentsMale[name][id]
            end
        else
            if ComponentsFemale[name] ~= nil then
                hash = ComponentsFemale[name][id]
            end
        end
    end
    return hash
end)

exports('SetFaceOverlays', function(target, data)
    LoadOverlays(target, data)
end)

exports('SetHair', function(target, data)
    LoadHair(target, data)
end)

exports('SetBeard', function(target, data)
    LoadBeard(target, data)
end)

exports('GetComponentsMax', function(name)
    if name == "hair" or name == "beard" then
        if IsPedMale(PlayerPedId()) then
            if hairs_list["male"][name] ~= nil then
                return #hairs_list["male"][name]
            end
        else
            if hairs_list["female"][name] ~= nil then
                return #hairs_list["female"][name]
            end
        end
    else
        if IsPedMale(PlayerPedId()) then
            if ComponentsMale[name] ~= nil then
                return #ComponentsMale[name]
            end
        else
            if ComponentsFemale[name] ~= nil then
                return #ComponentsFemale[name]
            end
        end
    end
end)

exports('GetMaxTexturesForModel', function(category , model)
    return GetMaxTexturesForModel(category,model)
end)

exports('ApplySkin', ApplySkin)