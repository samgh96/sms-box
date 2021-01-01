#!/bin/bash

# ---- build wla-dx ----
cd wla-dx

echo "------------------------------------"
echo "Building wla-dx..."

mkdir build && cd build
cmake ..
cmake --build . --config Release
# optional: install wla-dx in /usr/local/bin
if [[ ! -f /usr/local/bin/wla-z80 ]]; then
    echo "Installing wla-dx in /usr/local/bin..."
    sudo cmake -P cmake_install.cmake
fi
# ---- build meka ----
echo "------------------------------------"
echo "Building meka..."
cd ../../meka/meka/srcs
make
# ---- optional: add z80-mode to your emacs config (if you use emacs) ----
echo "------------------------------------"
echo "Setting up z80-mode in emacs..."
if [[ ! -f $HOME/.emacs.d/z80-mode.el ]]; then

  curl -o "$HOME"/.emacs.d/z80-mode.el https://raw.githubusercontent.com/SuperDisk/z80-mode/master/z80-mode.el

  if [[ -f $HOME/.emacs.d/init.el ]]; then
    echo "(if (file-exists-p \"${HOME}/.emacs.d/z80-mode.el\") (load-file \"${HOME}/.emacs.d/z80-mode.el\"))" >> "$HOME"/.emacs.d/init.el
  fi

fi

echo "------------------------------------"
echo "Done!"
