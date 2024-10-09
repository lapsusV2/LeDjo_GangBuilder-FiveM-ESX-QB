local Webhook = Discord.url

local logQueue, isProcessingQueue, logCount = {}, false, 0
local lastRequestTime, requestDelay = 0, 0
local function applyRequestDelay()
    local currentTime = GetGameTimer()
    local timeDiff = currentTime - lastRequestTime

    if timeDiff < requestDelay then
        local remainingDelay = requestDelay - timeDiff

        Wait(remainingDelay)
    end

    lastRequestTime = GetGameTimer()
end

local allowedErr = {
    [200] = true,
    [201] = true,
    [204] = true,
    [304] = true
}

---@param payload Log Queue
local function logPayload(payload)
    PerformHttpRequest(payload.webhook, function(err, text, headers)
        if err and not allowedErr[err] then
            print('^1Error occurred while attempting to send log to discord: ' .. err .. '^7')
            return
        end

        local remainingRequests = tonumber(headers["X-RateLimit-Remaining"])
        local resetTime = tonumber(headers["X-RateLimit-Reset"])

        if remainingRequests and resetTime and remainingRequests == 0 then
            local currentTime = os.time()
            local resetDelay = resetTime - currentTime

            if resetDelay > 0 then
                requestDelay = resetDelay * 1000 / 10
            end
        end
    end, 'POST', json.encode({content = payload.tag and '@everyone' or nil, embeds = payload.embed}), { ['Content-Type'] = 'application/json' })
end

local function processLogQueue()
    if #logQueue > 0 then
        local payload = table.remove(logQueue, 1)

        logPayload(payload)

        logCount += 1

        if logCount % 5 == 0 then
            Wait(60000)
        else
            applyRequestDelay()
        end

        processLogQueue()
    else
        isProcessingQueue = false
    end
end


function DiscordLog(title, message, tagEveryone)
    if Discord.url == '' then return end
    local tag = tagEveryone or false
    local webHook = Discord.url
    local embedData = {
        {
            ['title'] = title,
            ['color'] = Discord.color,
            ['footer'] = {
                ['text'] = os.date('%H:%M:%S %m-%d-%Y'),
            },
            ['description'] = message,
            ['author'] = {
                ['name'] = Discord.title,
                ['icon_url'] = Discord.imageUrl,
            },
        }
    }

    logQueue[#logQueue + 1] = {
        webhook = webHook,
        tag = tag,
        embed = embedData
    }

    if not isProcessingQueue then
        isProcessingQueue = true

        CreateThread(processLogQueue)
    end
end