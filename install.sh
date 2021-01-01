#!/bin/bash

ROOTDIR=$(pwd)

# ---- build wla-dx ----
cd wla-dx

echo "------------------------------------"

if [[ ! -f build ]]; then
    echo "Building wla-dx..."
    mkdir build && cd build
    cmake ..
    cmake --build . --config Release

    # optional: install wla-dx in /usr/local/bin
    # if [[ ! -f /usr/local/bin/wla-z80 ]]; then
    # 	echo "Installing wla-dx in /usr/local/bin..."
    # 	sudo cmake -P $ROOTDIR/wla-dx/build/cmake_install.cmake
    # fi
fi


# ---- build meka ----
echo "------------------------------------"
echo "Building meka..."
cd "$ROOTDIR"/meka/meka/srcs
make

cd "$ROOTDIR"

# if [[ ! -f /usr/local/bin/meka  ]]; then
#     echo "Linking meka bin to /usr/local/bin..."
#     echo $(realpath meka/meka/meka)
#     sudo ln -s $(realpath meka/meka/meka) /usr/local/bin/meka
# fi

echo "------------------------------------"
# ---- optional: add z80-mode to your emacs config (if you use emacs) ----
echo "Setting up z80-mode in emacs..."
if [[ ! -f $HOME/.emacs.d/z80-mode.el ]]; then

  curl -o "$HOME"/.emacs.d/z80-mode.el https://raw.githubusercontent.com/SuperDisk/z80-mode/master/z80-mode.el

  if [[ -f $HOME/.emacs.d/init.el ]]; then
    echo "(if (file-exists-p \"${HOME}/.emacs.d/z80-mode.el\") (load-file \"${HOME}/.emacs.d/z80-mode.el\"))" >> "$HOME"/.emacs.d/init.el
  fi

fi

echo "------------------------------------"
cd ~/
echo "Copying installation to /opt/sms-box..."
sudo cp "$ROOTDIR" /opt/sms-box
echo "------------------------------------"
echo "Done! Now you should update your PATH variable:"
echo "export PATH=/opt/sms-box/wla-dx/build/binaries:/opt/sms-box/meka/meka:\$PATH"
echo "Also set this alias to use meka: alias mekarun=/opt/sms-box/meka/meka/meka"
