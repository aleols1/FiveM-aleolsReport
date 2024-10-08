Config = {
    BotName = "Testern", -- Name of the bot that will send the reports to the discord channel
    Webhook = "https://discord.com/api/webhooks/1292201074115084462/rHdGNmI3Eo0kE1FdEeqlEeLS_F8DsmPs-Vimf50xhDdHWfKQVyxzA7OVey-PUvJRtlSh", -- Discord webhook link

    Admins = { -- Discord IDs of the admins
        "discord:1293156130486489088",
    },

    Translations = {
        ["report"] = "Rapport",
        ["report_alert"] = "Det er en ny rapport!",
        ["sent"] = "Sendt",
        ["report_sent"] = "Rapporten ble sendt.",
        ["deleted"] = "Slettet",
        ["report_deleted"] = "Rapporten ble slettet.",
        ["bring"] = "Admin",
        ["admin_bringed"] = "Ett staff medlem har hentet deg.",
        ["goto"] = "Admin",
        ["admin_came"] = "Ett staff medlem teleportert til deg for å hjelpe.",
        ["concluded"] = "Avsluttet",
    },

    Notification = function(title, message, msgType, length)
        -- Your notification here
    end
}
