#!/bin/bash

#Import of some vasiables variables
. /root/scripts/env_vars.conf

detect_distro(){
        if [ -f /etc/os-release ]
        then
                . /etc/os-release
                DISTRO=$ID
        fi
}


detect_distro

mkdir -p $build_dir && cd $build_dir

if [ "$DISTRO" = "debian" ] || [ "$DISTRO" = "Debian" ]
then
        CFLAGS="-ftree-vectorize -flto"
        if [[ "$(uname -m)" == "aarch64" ]]
        then
                CFLAGS="$CFLAGS -march=armv8-a+crc+crypto"
        elif [[ "$(uname -m)" == "x86_64" ]]
        then
                CFLAGS="$CFLAGS -march=core2 -mtune=intel"
        fi
        cmake $source_file_dir -DCMAKE_CXX_COMPILER="clang++-15" \
                -DCMAKE_C_COMPILER=clang-15 \
                -DCMAKE_CXX_FLAGS="-O2 -g -stdlib=libc++" \
                -DUSE_DISCORD_PRESENCE=OFF -DENABLE_SDL2=OFF -DENABLE_QT=OFF -DENABLE_LTO=ON \
                -DENABLE_VULKAN=OFF -DENABLE_LIBUSB=OFF -DENABLE_CUBEB=OFF \
                -DENABLE_SOFTWARE_RENDER=OFF -DENABLE_OPENGL=OFF \
                -DENABLE_ROOM_STANDALONE=ON
        cmake --build . -- -j"$(nproc)"
else
                CFLAGS="-ftree-vectorize -flto"
        if [[ "$(uname -m)" == "aarch64" ]]
        then
                CFLAGS="$CFLAGS -march=armv8-a+crc+crypto"
        elif [[ "$(uname -m)" == "x86_64" ]]
        then
                CFLAGS="$CFLAGS -march=core2 -mtune=intel"
        fi
        cmake $source_file_dir -DCMAKE_CXX_COMPILER=clang++ \
                -DCMAKE_C_COMPILER=clang \
                -DCMAKE_CXX_FLAGS="-O2 -g -stdlib=libc++" \
                -DUSE_DISCORD_PRESENCE=OFF -DENABLE_SDL2=OFF -DENABLE_QT=OFF -DENABLE_LTO=ON \
                -DENABLE_VULKAN=OFF -DENABLE_LIBUSB=OFF -DENABLE_CUBEB=OFF \
                -DENABLE_SOFTWARE_RENDER=OFF -DENABLE_OPENGL=OFF \
                -DENABLE_ROOM_STANDALONE=ON
        cmake --build . -- -j"$(nproc)"
fi
