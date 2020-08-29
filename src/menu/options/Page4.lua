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

local NB2withHandler = {}
for k, v in pairs(S.NB2) do
    NB2withHandler[k] = v
end

function NB2withHandler:click()
    Sounds.playLooping(musicfiles[self.id].filename)
end


local MusicSelectMenu = Y.VDiv(
    Y.Label(L["musicswitcher"], S.LS, "musicselecttitle"),
    Y.Button(musicfiles["track01"].title, NB2withHandler, "track01"),
    Y.Button(musicfiles["track02"].title, NB2withHandler, "track02"),
    Y.Button(musicfiles["track03"].title, NB2withHandler, "track03"),
    Y.Button(musicfiles["track04"].title, NB2withHandler, "track04"),
    Y.Button(musicfiles["track05"].title, NB2withHandler, "track05"),
    Y.Button(musicfiles["track06"].title, NB2withHandler, "track06"),
    Y.Button(musicfiles["track07"].title, NB2withHandler, "track07"),
    Y.Button(musicfiles["track08"].title, NB2withHandler, "track08"),
    Y.Button(musicfiles["track09"].title, NB2withHandler, "track09"),
    Y.Button(musicfiles["track10"].title, NB2withHandler, "track10"),
    {
        placement = "center",
        gap = 3
    },
    "optionsPage4"
)

-- music change buttons

-- TO DO: the previously played loop should be stopped before starting the new track

return MusicSelectMenu