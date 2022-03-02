local _hints = {}
local _hintsCount = 0
local showHints = true

-- [key] = {text, displayAmount, extraData}
local function Register(hints, forResource)
    if hints then
        local resource = forResource and forResource:lower() or GetInvokingResource()

        if not _hints[resource] then _hints[resource] = {} end

        for hintKey, hintData in pairs(hints) do
            _hints[resource][hintKey] = {
                text = tostring(hintData[1]),
                displayAmount = tonumber(hintData[2]) or 1,
                displayCount = 0,
                extraData = hintData[3] or nil
            }
            _hintsCount = _hintsCount+1
        end

        print('Registered Hints for ' .. resource)
        print('Total ' .. _hintsCount)
    end
end

local function RemoveHint(hintKey)
    for resource, resourceHints in pairs(_hints) do
        for key, _ in pairs(resourceHints) do
            if key == hintKey then
                _hints[resource][key] = nil
                return true
            end
        end
    end

    return false
end

local function Display(hintKey, displayOverride, fromResource) -- Can be string or number
    if not showHints then return end

    local resource = fromResource and fromResource:lower() or GetInvokingResource()

    if _hints[resource] then
        if not _hints[resource][hintKey] then return end

        local hint = _hints[resource][hintKey]

        if hint.displayAmount == 0 or hint.displayCount < hint.displayAmount or displayOverride then
            TriggerEvent('hintTriggered', resource, _hints[resource][hintKey])
            
            if hint.displayCount < hint.displayAmount then _hints[resource][hintKey].displayCount = _hints[resource][hintKey].displayCount+1 end
        end
    end
end

local function Toggle(toggle)
    if toggle == showHints then return end

    showHints = toggle or not showHints

    TriggerEvent('hintsToggled', showHints)
end

AddEventHandler('onResourceStop', function(resourceName)
    if _hints[resourceName] then
        _hints[resourceName] = nil
        print('Hints removed for resource ' .. resourceName)
    end
end)

RegisterCommand(Config.CommandName, function() Toggle() end, false)

--[[ RegisterCommand('hint', function(source, args, rawCommand)
    if tostring(args[1]) and tostring(args[2]) then Display(args[1], false, args[2]) end
end, false) ]]

RegisterNetEvent('registerHints', Register)
RegisterNetEvent('displayHint',   Display)
RegisterNetEvent('toggleHints',   Toggle)

exports('Display',  Display)
exports('Register', Register)
exports('Toggle',   Toggle)