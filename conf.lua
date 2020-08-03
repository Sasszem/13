function love.conf(t)
    t.window.width = 360 --1080
    t.window.height = 679--1920
    t.window.title="13"
    t.window.icon="asset/13_icon.png"

    --version is also stored in globals.lua
    t.releases = {
        title = "13",
        package = "13",
        loveVersion = "11.3",
        version = "v1.1.0-pre",
        author = "Sasszem",
        email = "barath.laszlo.szolnok@gmail.com",
        description = "A simple but addictive game",
        homepage = "https://github.com/sasszem/13",
        excludeFileList = {
            ".git",
            ".vscode",
            "asset/apkStuff",
            "apk",
            "jar",
        },
      }
end