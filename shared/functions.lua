local clothing = require 'data.clothing'
local hairs_list = require 'data.hairs_list'

--- Builds a set of all valid clothing + hair hashes for validation
local validHashes = nil
local function BuildValidHashSet()
    if validHashes then return end
    validHashes = {}
    for _, genderData in pairs(clothing) do
        for _, categoryData in pairs(genderData) do
            for _, modelData in pairs(categoryData) do
                for _, textureData in pairs(modelData) do
                    if textureData.hash then
                        validHashes[tonumber(textureData.hash)] = true
                    end
                end
            end
        end
    end
    for _, genderData in pairs(hairs_list) do
        for _, categoryData in pairs(genderData) do
            for _, modelData in pairs(categoryData) do
                for _, textureData in pairs(modelData) do
                    if textureData.hash then
                        validHashes[tonumber(textureData.hash)] = true
                    end
                end
            end
        end
    end
end

--- Validates that all hash values in newClothes exist in the clothing data
---@param newClothes table
---@param isMale boolean
---@return boolean, string|nil
function ValidateClothesData(newClothes, isMale)
    if type(newClothes) ~= 'table' then
        return false, 'Invalid clothes data'
    end
    BuildValidHashSet()
    local clothingG = isMale and clothing['male'] or clothing['female']
    for categoryName, item in pairs(newClothes) do
        if type(item) ~= 'table' then
            return false, 'Invalid item data for ' .. tostring(categoryName)
        end
        if not clothingG[categoryName] then
            local hairGender = isMale and 'male' or 'female'
            if not hairs_list[hairGender] or not hairs_list[hairGender][categoryName] then
                return false, 'Invalid category: ' .. tostring(categoryName)
            end
        end
        if item.hash then
            local hash = tonumber(item.hash)
            if not hash or not validHashes[hash] then
                return false, 'Invalid hash for category: ' .. tostring(categoryName)
            end
        end
    end
    return true
end

function CalculatePrice(newClothes, currentClothes, isMale)
    local price = 0
    local clothingG = isMale and clothing['male'] or clothing['female']
    for categoryName,_ in pairs(clothingG) do
        local newHash = newClothes[categoryName]?.hash
        local currentHash = currentClothes[categoryName]?.hash
        if newHash and newHash ~= currentHash then
            price = price + RSG.Price[categoryName]
        end
    end
    return price
end