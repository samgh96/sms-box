#!/bin/bash

# ---- build wla-dx ----
cd wla-dx
mkdir build && cd build
cmake ..
cmake --build . --config Release
# optional: install wla-dx in /usr/bin
# sudo cmake -P cmake_install.cmake
# ---- build blastem ----
# cd ../../blastem
# make
# ---- build meka ----
cd meka/meka/srcs
make
# ---- optional: add z80-mode to your emacs config (if you use emacs) ----
if [[ ! -f $HOME/.emacs.d/z80-mode.el ]]; then

  curl -o "$HOME"/.emacs.d/z80-mode.el https://raw.githubusercontent.com/SuperDisk/z80-mode/master/z80-mode.el

  if [[ -f $HOME/.emacs.d/init.el ]]; then
    echo "(if (file-exists-p \"${HOME}/.emacs.d/z80-mode.el\") (load-file \"${HOME}/.emacs.d/z80-mode.el\"))" >> "$HOME"/.emacs.d/init.el
  fi

fi
