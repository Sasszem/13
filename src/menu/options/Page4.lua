local Y = require("yalg.yalg")

local L = require("src.Local")
local Sounds = require("src.Sounds")
local S = require("src.menu.options.styles")

local musicfiles={
    track01={title='All Hail Victor', filename='loop'},
    track02={title='Autumn Leaves', filename='POL-autumn-leaves-short'},
    track03={title='Carried Away', filename='POL-carried-away-short'},
    track04={title='Course of Nature', filename='POL-course-of-nature-short'},
    track05={title='Foggy Forest', filename='POL-foggy-forest-short'},
    track06={title='Good Morning', filename='POL-good-morning-short'},
    track07={title='Hills at Dawn', filename='POL-hills-at-dawn-short'},
    track08={title='Perfect Bliss', filename='POL-perfect-bliss-short'},
    track09={title='Skyline', filename='POL-skyline-short'},
    track10={title='Water World', filename='POL-water-world-short'},
}

local LanguageSelectMenu = Y.VDiv(
    Y.Label(L["musicswitcher"], S.LS, "musicselecttitle"),
    Y.Button(musicfiles["track01"].title, S.NB2, "track01"),
    Y.Button(musicfiles["track02"].title, S.NB2, "track02"),
    Y.Button(musicfiles["track03"].title, S.NB2, "track03"),
    Y.Button(musicfiles["track04"].title, S.NB2, "track04"),
    Y.Button(musicfiles["track05"].title, S.NB2, "track05"),
    Y.Button(musicfiles["track06"].title, S.NB2, "track06"),
    Y.Button(musicfiles["track07"].title, S.NB2, "track07"),
    Y.Button(musicfiles["track08"].title, S.NB2, "track08"),
    Y.Button(musicfiles["track09"].title, S.NB2, "track09"),
    Y.Button(musicfiles["track10"].title, S.NB2, "track10"),
    {
        placement = "center",
        gap = 3
    },
    "optionsPage4"
)




local function selectLang(lang)
    L.set(lang)
    L.load()
    LanguageSelectMenu:getWidget("restartLbl").text = L["restartrequired"]
end


-- music change buttons

-- TO DO: the previously played loop should be stopped before starting the new track

function LanguageSelectMenu.widgets.track01.style:click()
    Sounds.playLooping(musicfiles["track01"].filename)
end

function LanguageSelectMenu.widgets.track02.style:click()
    Sounds.playLooping(musicfiles["track02"].filename)
end

function LanguageSelectMenu.widgets.track03.style:click()
    Sounds.playLooping(musicfiles["track03"].filename)
end

function LanguageSelectMenu.widgets.track04.style:click()
    Sounds.playLooping(musicfiles["track04"].filename)
end

function LanguageSelectMenu.widgets.track05.style:click()
    Sounds.playLooping(musicfiles["track05"].filename)
end

function LanguageSelectMenu.widgets.track06.style:click()
    Sounds.playLooping(musicfiles["track06"].filename)
end

function LanguageSelectMenu.widgets.track07.style:click()
    Sounds.playLooping(musicfiles["track07"].filename)
end

function LanguageSelectMenu.widgets.track08.style:click()
    Sounds.playLooping(musicfiles["track08"].filename)
end

function LanguageSelectMenu.widgets.track09.style:click()
    Sounds.playLooping(musicfiles["track09"].filename)
end

function LanguageSelectMenu.widgets.track10.style:click()
    Sounds.playLooping(musicfiles["track10"].filename)
end

return LanguageSelectMenu