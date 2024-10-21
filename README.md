# TIC-Smash

a fighting game inspired by [Super Smash Bros.](https://www.smashbros.com/) available and made with [TIC-80](https://tic80.com).

Game is playable at [TIC-80 website](https://tic80.com/play?cart=4036)

**[Super Smash Bros.](https://www.smashbros.com/) by Nintendo**

## Screenshots

<img src="./Images/8-BIT_Panda_STELE.png" style="width:512px">
<img src="./Images/STELE_Nesbox_hayattgd.png" style="width:512px">

## Build

First, you need to clone and go into TIC-Smash directory.

```sh
git clone https://github.com/hayattgd/TIC-Smash.git
cd TIC-Smash
```

And, its recommend to set variable %TIC80% to path to your TIC-80 executable.

### .TIC

```sh
%TIC80% --cli --fs=./ --cmd="load TIC-Smash.lua & cd Version & save LATEST.tic & exit"
rm .local
```

### Windows

```sh
%TIC80% --cli --fs=./ --cmd="load TIC-Smash.lua & export win LATEST alone=1 & exit"
rm .local
```

## Contributing

To contribute development of TIC-Smash, fork this repository and edit it, then make a pull request.

Or, simply make new issue about bugs or suggestions. Sharing TIC-Smash to friends is also good :)

<sub>downloading [TIC-80 syntax](https://github.com/hayattgd/TIC-80-syntax) is recommend when development</sub>

## To-do

### Planned (v0.8)

- [x] Playable Character
- [x] Non-player character
- [x] Title
- [x] Stage Select
- [x] Character Select
- [x] Timer / Score
- [x] Result

### Ideas / Plans to brush up (v1.0)

- [ ] BGM / SFX / Particles
- [x] More stages
- [ ] More characters (around 12)
- [x] Another special attack
- [ ] Story thing (PvE)
- [ ] Custom character
- [ ] Custom stage
- [ ] 4 player battle
- [ ] ~~More ways to attack~~
- [ ] ~~Boss fight~~
- [ ] ~~Item~~
- [ ] ~~Assist Figure~~
- [ ] ~~Final smash~~

(strikethrough text idea is low possibility due to sprite limits)

## Changelog

each versions saved as .tic format in [Version](./Version) folder

### v0.1

**First release!**

- Bot that automatically fights
- 1 stage
- 2 characters
- some effects / sfx on jumping / smashing
- every character has same special

### v0.4

**more stage / character!**

- 3 stage added
- 2 character added
- each character has own special (wip)
- stage and character is shuffled in each play

### v0.8

**huge update!**

- intro, title added
- stage / character select added (wip)
- option to switch default or stage palette
- added balmung stage and character
- added 1~6 level for bot
- added timer / result on battle (wip)
- can choose character is controlled by bot or player

## Credits

### Used stuffs

| Original                                                    | Developer                                                  | Used Parts                  |
|-------------------------------------------------------------|------------------------------------------------------------|-----------------------------|
|                                                             | [Nesbox](https://tic80.com/dev?id=1)                       | Icon                        |
| [8-BIT Panda](https://tic80.com/play?cart=188)              | [Bruno Oliveira (btco)](https://tic80.com/dev?id=339)      | Character / Tiles / Palette |
| [STELE](https://tic80.com/play?cart=483)                    | [Zus (captainzus)](https://tic80.com/dev?id=1185)          | Character / Tiles / Palette |
| [Balmung](https://tic80.com/play?cart=636)                  | [petet](https://tic80.com/dev?id=1720)                     | Character / Tiles / Palette |
| [MARIO BROS. (Demake)](https://tic80.com/play?cart=223)     | [trelemar](https://tic80.com/dev?id=5)                     | Tiles / Palette             |
| Original MARIO BROS.                                        | Nintendo                                                   |                             |
| [Super Meat Boy (Demake)](https://tic80.com/play?cart=1512) | [nequ16 (Never)](https://tic80.com/dev?id=2178)            | Character / Tiles / Palette |
| Original Super Meat Boy                                     | Team Meat                                                  |                             |
| Among us                                                    | Innersloth                                                 | Character                   |

<sub>*Some Sprites / Tiles will shown in-game with another palette depending on situation</sub>

### Inspired by

| Original                                                    | Developer                                                  | Inspired Parts              |
|-------------------------------------------------------------|------------------------------------------------------------|-----------------------------|
| [TICHOU (Demake)](https://tic80.com/play?cart=4007)         | [SineLuciditate](https://tic80.com/dev?id=10773)           | Character                   |
| Original Touhou                                             | ZUN                                                        |                             |

## Licenses

| Product                                        | License                                                           |
|------------------------------------------------|-------------------------------------------------------------------|
| [8-BIT Panda](https://tic80.com/play?cart=188) | [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) |

This repository is available under [MIT License](./LICENSE)
