# 13 dev log

## Day 1 - 2020.06.01

- Uploaded project base to github
- Found a crazy issue about mobile resolution - trying to center a rect in the screen actually displays a quarter of it in the bottom-right corner. Did not find any solutions for that.
- Worked on another project that neared an important milestone - and had some succes with that

## Day 2 - 2020.06.02

- Revisited one of my older project stubs, which did not have this issue for some reason - still did not figure out why
- Spent some good time trying to solve that issue
- Gave up at 10pm and figured I'll just use `love.graphics.scale(0.5, 0.5)` as a workaround
Also additional coordinate transform
- simple packer script - should be later replaced by love-release
- Add Path base
- some github stuff

## Day 3 - 2020.06.03

- Merge animation using a coroutine - those things are amazing!
- Shifting down animation - with a coroutine
- Path - undo, do not allow 1-1-2 pattern
- Cell replenish and size animation - with a coroutine
- Decrease 2 cell chance

## Day 4 - 2020.06.08

- Draw merge cell above normal cells
- Freeze gameplay while animating
- Remove merge side-effects
- Minor refactors
- Add basic sounds
- Add [CREDITS.md](CREDITS.md)
- Speed up all animations
- fix shiftdown making the grid un-aligned
- add more cell colors

Finished working at 03:14 am

## Day 5 - 2020.06.09

- fix mobile coordinate system for good
Was a long fix, as the resolution actually changes more than once while initializing.

- Make "task" system and refactor with it
- Add timer & score

Finished at 02:56 am

### Day 6 - 2020.06.10

- A huge refactor
- fix: disallow merging while animating
- basic loading and saving

Finished at 04:06 am
Messed up branch (and merge commit) name as day 7

### Day 7 - 2020.06.11

- finish save system
- undo function base
- game end base
- setup YALG GUI lib

Finished working at 03:40 am

### Day 8 - 2020.06.12

- Menu base
- Highscore saving
- timer mode base

Finished at 02:31 am
