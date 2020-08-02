local L = require("src.Local")
local S = require("src.menu.options.styles")


local LanguageSelectMenu = VDiv(
    Label(L["languageswitcher"], S.LS, "languageselecttitle"),
    Button("English", S.NB, "english"),
    Button("Magyar", S.NB, "magyar"),
    Label("", {span=2}),
    Label("", S.NS, "restartLbl"),
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