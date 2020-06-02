rm -f game.love || true
zip game.zip -r .
zip game.zip -d .git
mv game.zip game.love
