# 13

Recreation of a simple game

## To play

Grab a download from the releases page. The .love bundles need Löve2D version 11.3 or compatible. Works on every platform supported by Löve2D, but the main target is android - so just grab the apk version if you can.

You can also try out the web version (.html file), altought that's slower and hase a few sound issues.

## To build using Docker

Prerequisites:
- GIT
- Docker

1. Clone repo **with submodules**:
`git clone --recurse-submodules git://github.com/sasszem/13.git`
2. Build container: 
`DOCKER_BUILDKIT=0 docker build -t love-apk-builder builder-cont`
3. Build using container: 
`docker run --rm -v "$(pwd)":/project love-apk-builder`

(getting `sh: love: not found` lines is normal and should not effect the build process)

## To build without container

Prerequisites:
- you must have a posix system with `wget` and `Java 8+` installed
- build and install [luarocks3](https://github.com/luarocks/luarocks/wiki/Download)
- `sudo luarocks install love-release`
- install [apktool](https://ibotpeaches.github.io/Apktool/install/)

Actuall building:
- Clone this repo **with submodules**: 
`git clone --recurse-submodules git://github.com/sasszem/13.git`
- `lua build.lua`

## The original

I got the idea from a mobile game "Make it 13" (later renamed to "Number merger infinity"), which was quite addictive, but poorly implemented, and had quite a few ads.

## Project goals

 Functional game:  

- board, cells, merging, animations
- menus
- background images, background ambient music
- highscores
- works on android

Check out the [DEVLOG](DEVLOG.md)
For stuff I used, check out [CREDITS](CREDITS.md)

Project due date: 2020.06.14
I should put all my other sideprojects aside for that time!
