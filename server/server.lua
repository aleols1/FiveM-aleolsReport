Framework = exports['es_extended']:getSharedObject()
Admins = {}
Reports = {}
local reportId = 0

RegisterServerEvent('aleolsReport:server:loaded', function()
    local src = source

    for i, identifier in pairs(Config.Admins) do
        if _GetPlayerIdentifier(src) == identifier then

            table.insert(Admins, src)

            for _, admin in pairs(Admins) do
                TriggerClientEvent("aleolsReport:client:loaded", admin, Admins, Reports)
            end
        end
    end
end)

RegisterServerEvent('aleolsReport:server:sendReport', function(data)
    local src = source
    reportId = reportId + 1
    data.reporter = {}
    data.reporter.id = src

    local xPlayer = Framework.GetPlayerFromId(src)
    data.reporter.name = xPlayer.getName()

    data.reportId = reportId

    table.insert(Reports, data)

    for _, admin in pairs(Admins) do
        TriggerClientEvent("aleolsReport:client:sendReport", admin, data)
    end

    local id = _GetPlayerIdentifier(src, 0)
    local plyName = GetPlayerName(src)
    local msgData = {
        message = 
        '**[Spiller]: **'..plyName..'\n'..
        '**[ID]: **'..src..'\n'..
        '**[Lisens]: **'..id..'\n'..
        '**[Emne]: **'..data.subject..'\n'..
        '**[Melding]: **'..data.message..'\n'
    }
    
    SendWebhook(Config.BotName, msgData, Config.Translations["report_alert"], Config.Webhook)
end)

RegisterServerEvent('aleolsReport:server:concludeReport', function(reportId, asister)
    local src = source
    local id = _GetPlayerIdentifier(src)
    local plyName = GetPlayerName(src)
    local msgData = {
        message = 
        '**[Spiller]: **'..plyName..'\n'..
        '**[Lisens]: **'..id..'\n'..
        '**[Rapport ID]: **'..reportId..'\n'..
        '**[Avsluttet av]: **'..asister..'\n'
    }
    
    SendWebhook(Config.BotName, msgData, Config.Translations["concluded"], Config.Webhook)

    for i, report in pairs(Reports) do
        if report.reportId == reportId then
            report.concluded = true
            report.concludedby = asister

            for _, admin in pairs(Admins) do
                TriggerClientEvent("aleolsReport:client:updateReports", admin, Reports)
            end
        end
    end
end)

RegisterServerEvent('aleolsReport:server:deleteReport', function(reportId)
    local src = source
    local id = _GetPlayerIdentifier(src, 0)
    local plyName = GetPlayerName(src)
    local msgData = {
        message = 
        '**[Spiller]: **'..plyName..'\n'..
        '**[Lisens]: **'..id..'\n'..
        '**[Rapport ID]: **'..reportId..'\n'
    }
    
    SendWebhook(Config.BotName, msgData, Config.Translations["deleted"], Config.Webhook)

    for i, report in pairs(Reports) do
        if report.reportId == reportId then
            table.remove(Reports, i)

            for _, admin in pairs(Admins) do
                TriggerClientEvent("aleolsReport:client:updateReports", admin, Reports)
            end
        end
    end
end)

RegisterServerEvent('aleolsReport:server:alertPlayer', function(player, alertType)
    TriggerClientEvent("aleolsReport:client:alertPlayer", player, alertType)
end)

RegisterServerEvent('aleolsReport:server:gotoPlayer', function(player)
    local src = source
    local targetPed = GetPlayerPed(player)

    if not targetPed then return end
    local myPed = GetPlayerPed(src)
    local targetCoords = GetEntityCoords(targetPed)

    TriggerEvent('aleolsReport:server:alertPlayer', player, "goto")

    SetEntityCoords(myPed, targetCoords)
end)

RegisterServerEvent('aleolsReport:server:bringPlayer', function(player)
    local src = source
    local targetPed = GetPlayerPed(player)

    if not targetPed then return end
    local myPed = GetPlayerPed(src)
    local myCoords = GetEntityCoords(myPed)

    TriggerEvent('aleolsReport:server:alertPlayer', player, "bring")

    SetEntityCoords(targetPed, myCoords)
end)

AddEventHandler('playerDropped', function()
    local src = source
    local admin = IsAdmin(src)
    
    if admin then
        for i, admin2 in pairs(Admins) do
            if admin2 == admin then
                table.remove(Admins, i)
                TriggerClientEvent("aleolsReport:client:updateAdmins", admin, Admins)
            end
        end
    end
end)