#!/bin/bash

ROOTDIR=$(pwd)

if [[ ! -d bins ]]; then
    mkdir bins
fi

# ---- build wla-dx ----
echo "---- WLA-DX ----"
# which wlalink 1> /dev/null
false
if [ $? -eq 1 ]; then
    if [[ ! -d wla-dx/build ]]; then

        echo "Building wla-dx..."
        cd wla-dx
        mkdir build && cd build
        cmake ..
        cmake --build . --config Release

        if [ ! $? -eq 0 ]; then
            echo "wla-dx build failed! Exiting..."
            exit 1
        else
            echo "wla-dx built!"
        fi
        cd "$ROOTDIR"
        echo "Copying wla-dx binaries to bins folder..."
        cp wla-dx/build/binaries/* bins/
    fi
else
    echo "wla-dx already present! Skipping..."
fi

# ---- build meka ----
echo "---- MEKA ----"
if [[ -d /usr/include/allegro5 ]]; then
    
    which meka 1> /dev/null
    if [ $? -eq 1 ]; then
        echo "Building meka..."
        cd "$ROOTDIR"/meka/meka/srcs
        make

        if [ $? -eq 0 ]; then
            echo "meka build failed! Exiting..."
            exit 1
        else
            echo "meka built!"
        fi
    else
        echo "meka already present! Skipping..."
    fi
else
    echo "Missing allegro5, rerun after you install allegro5. Skipping..."
fi

cd "$ROOTDIR"

# ---- set up devkitSMS ----
echo "---- devkitSMS ----"
if [[ ! -f /usr/share/sdcc/lib/z80/SMSlib.lib ]]; then
    which sdcc 1> /dev/null
    if [ $? -eq 0 ]; then        
        # copy bins to new bin folder,
        echo "Copying devkitSMS binaries to bins folder..."
        cp devkitSMS/makesms/Linux/makesms bins/
        cp devkitSMS/ihx2sms/Linux/ihx2sms bins/
        cp devkitSMS/assets2banks/src/assets2banks.py bins/assets2banks
        chmod +x bins/assets2banks
        echo "Linking libs to /usr/share/sdcc/lib, sudo is required..."
        sudo cp devkitSMS/SMSlib/SMSlib.lib /usr/share/sdcc/lib/z80/
        # maybe we could include here SMSlib_GG.lib but I really don't know
    else
        echo "Missing sdcc, rerun after you install sdcc. Skipping..."
    fi
else
    echo "devkitSMS already installed, skipping..."
fi

# ---- optional: add z80-mode to your emacs config (if you use emacs) ----
which emacs 1> /dev/null
if [ $? -eq 0 ]; then
    echo "---- z80-mode ----"
    if [[ ! -f $HOME/.emacs.d/z80-mode.el ]]; then

        curl -o "$HOME"/.emacs.d/z80-mode.el https://raw.githubusercontent.com/SuperDisk/z80-mode/master/z80-mode.el

        if [[ -f $HOME/.emacs.d/init.el ]]; then
            echo "(if (file-exists-p \"${HOME}/.emacs.d/z80-mode.el\") (load-file \"${HOME}/.emacs.d/z80-mode.el\"))" >> "$HOME"/.emacs.d/init.el
        fi

    else
        echo "z80-mode already present! Skipping..."
    fi
else
    echo "Missing emacs, rerun after you install emacs. Skipping..."
fi

echo "------------------------------------"
echo "Copying installation to /opt/sms-box..."
cd "$ROOTDIR"
cd ..
sudo cp -r "$ROOTDIR" /opt/sms-box
sudo chown -R $USER /opt/sms-box
# link bins or libs or whatever now, not before!
echo "------------------------------------"
echo "Done! Now you should update your PATH variable:"
echo "export PATH=/opt/sms-box/bins:/opt/sms-box/meka/meka:\$PATH"
echo "Also set this alias to use meka:"
echo "alias mekarun=/opt/sms-box/meka/meka/meka"
