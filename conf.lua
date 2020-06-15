function love.conf(t)
    t.window.width = 360 --1080
    t.window.height = 679--1920

    t.releases = {
        title = "13",
        package = "13",
        loveVersion = "11.3",
        version = "1.0",
        author = "Sasszem",
        email = "barath.laszlo.szolnok@gmail.com",
        description = "A simple but addicitve game",
        homepage = "https://github.com/sasszem/13",
        excludeFileList = {
            ".git",
            ".vscode"
        },
      }
end