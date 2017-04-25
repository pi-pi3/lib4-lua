# lib4-lua
`lib4-lua` is a collection of tiny lua files with filenames consisting of 4
letters + extension.

## included libraries:
- `util.lua` General purpose utilities for games.
- `lgui.lua` General purpose gui for games (requires löve).

### collections
- `list.lua` General purpose singly-linked list optimized with tail-calls.
- `vec2.lua` and `vec3.lua` Easy vectors for games.

### other
- `rect.lua` A rectangle for collision checks.

### submodules
- `autobatch` Small LÖVE module to automate the use of SpriteBatches
- `log.lua` A tiny logging module for Lua
- `tick` Lua module for delaying function calls

## util.lua
Most functions are documented and are so tiny, they're rather easy to understand.

## lgui.lua
Literally 10 comments in the entire file. I will document it sometime. For now,
look at how `src/menu.lua` uses `lgui` and launch the test suite using `love src`.

## Customization
To customize this repository for your project, you'll have to do the following:
1. customize this README
2. customize config.mk
3. change the name of the game in the following places:
 - release/linux/launch.sh (game title, aka $GAME)
 - release/mac/game.app (the name of this directory)
 - release/mac/game.app/Info.plist (all places marked with #XXX)
 - src/conf.lua (t.identity and t.window.title)

## Testing
You can test some features by launching the included binary located in
releases/<your-os>.

## Other libraries
Other libraries that might be useful for you, but weren't included as
submodules.  
- `lume` Lua functions geared towards gamedev
- `lovebpm` A LÖVE library for syncing events to the BPM of an audio track
- `classic` Tiny class module for Lua
- `lurker` Auto-swaps changed Lua files in a running LÖVE project
