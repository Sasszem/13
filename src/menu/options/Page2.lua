local Y = require("yalg.yalg")

local L = require("src.Local")
local S = require("src.menu.options.styles")


local LanguageSelectMenu = Y.VDiv(
    Y.Label(L["languageswitcher"], S.LS, "languageselecttitle"),
    Y.Button("English", S.NB, "english"),
    Y.Button("Magyar", S.NB, "magyar"),
    Y.Label("", {span=2}),
    Y.Label("", S.NS, "restartLbl"),
    {},
    "optionsPage2"
)


local function selectLang(lang)
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


return LanguageSelectMenu