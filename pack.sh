rm -f first.love || true
zip game.zip -r .
zip game.zip -d .git
mv game.zip first.love
