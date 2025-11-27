local clothing = require 'data.clothing'

local HashToCache = {}
local LookupBuilt = false

local function BuildHashLookup()
    if LookupBuilt then return end
    
    for gender, genderData in pairs(clothing) do
        for category, categoryData in pairs(genderData) do
            if type(categoryData) == 'table' then
                for modelId, modelData in pairs(categoryData) do
                    if type(modelData) == 'table' then
                        for textureId, textureData in pairs(modelData) do
                            if type(textureData) == 'table' and textureData.hash then
                                local hash = tonumber(textureData.hash)
                                if hash then
                                    HashToCache[hash] = {
                                        gender = gender,
                                        category = category,
                                        model = modelId,
                                        texture = textureId
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    LookupBuilt = true
end

local function ConvertHashToCache(hashBasedClothes, isMale)
    BuildHashLookup()
    
    local newCache = {}
    
    if not hashBasedClothes or type(hashBasedClothes) ~= 'table' then
        return newCache
    end
    
    for category, item in pairs(hashBasedClothes) do
        if item and type(item) == 'table' then
            if item.hash then
                local hash = tonumber(item.hash)
                local lookup = HashToCache[hash]
                
                if lookup then
                    newCache[category] = {
                        model = lookup.model,
                        texture = lookup.texture
                    }
                else
                    newCache[category] = {
                        model = 0,
                        texture = 1
                    }
                end
            elseif item.model and item.texture then
                newCache[category] = {
                    model = tonumber(item.model),
                    texture = tonumber(item.texture)
                }
            else
                newCache[category] = {
                    model = 0,
                    texture = 1
                }
            end
        else
            newCache[category] = {
                model = 0,
                texture = 1
            }
        end
    end
    
    return newCache
end

local function InitializeAllCategories(cache, isMale)
    local genderKey = isMale and 'male' or 'female'
    local allCategories = clothing[genderKey]
    
    if not allCategories then return cache end
    
    for category, _ in pairs(allCategories) do
        if cache[category] == nil then
            cache[category] = {
                model = 0,
                texture = 1
            }
        end
    end
    
    return cache
end

local function PopulateClothingCache(loadedClothes, isMale)
    local convertedCache = ConvertHashToCache(loadedClothes, isMale)
    local initializedCache = InitializeAllCategories(convertedCache, isMale)
    return initializedCache
end

return {
    BuildHashLookup = BuildHashLookup,
    ConvertHashToCache = ConvertHashToCache,
    InitializeAllCategories = InitializeAllCategories,
    PopulateClothingCache = PopulateClothingCache
}
