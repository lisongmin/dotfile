#!/bin/bash

sudo localectl --no-convert set-keymap dvorak-programmer
sudo localectl --no-convert set-x11-keymap us pc105 dvp terminate:ctrl_alt_bksp

# reset
# sudo localectl --no-convert set-keymap us
# sudo localectl --no-convert set-x11-keymap us pc101
