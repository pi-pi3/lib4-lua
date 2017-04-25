#!/usr/bin/sh
DIR="$(dirname "${BASH_SOURCE[0]}")"
GAME="game"
love "$DIR/$GAME.love"
