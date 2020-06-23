-- src/menu/LanguageSelectMenu.lua

local L = require("src.Local")

local BS = require("src.menu.buttonStyle")
local LS = require("src.menu.labelStyle")

local LanguageSelectMenu = VDiv(
    Button("English", BS, "english"),
    Button("Magyar", BS, "magyar"),
    Label("", {span = 5}),
    Button(L["back"], BS, "backFromLang"),
    Label(L["restartrequired"], LS, "restartLbl"),
    {
        gap = 10,
        margin = 50,
    },
    "languageSelect"
)


function selectLang(lang)
    L.set(lang)
    L.load()
    LanguageSelectMenu:getWidget("restartLbl").text = L["restartrequired"]
end



-- language buttons

function LanguageSelectMenu.widgets.english.style:click()
    selectLang("EN")
end

function LanguageSelectMenu.widgets.magyar.style:click()
    selectLang("HU")
end

-- back button
function LanguageSelectMenu.widgets.backFromLang.style:click()
    self:getWidget("switcher").selected = "options"
end

return LanguageSelectMenu