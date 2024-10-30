# README #

THIS REPO IS A COPY OF PHILIP BROUKES WORK. IT HAS BEEN EDITTED TO WORK WITH C++ INSTEAD OF C.

This project is a cross-platform Makefile starter kit designed to build desktop binaries (bin/exe) and web-based versions using Raylib and Emscripten. It provides a solid foundation for developing graphical applications or games that run on Linux, Windows, and the web.

## Project Overview
This starter kit allows developers to quickly set up a cross-platform development environment using Raylib for graphics rendering and Emscripten for compiling to the web. The project structure supports both desktop (Linux and Windows) and web (HTML/JavaScript) builds, making it easy to target multiple platforms from a single codebase. This starter kit is ideal for building 2D/3D games or interactive applications with minimal setup effort.

## Table of Contents
- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Instructions for Linux](#instructions-for-linux)
- [Instructions for Windows using MSYS2](#instructions-for-windows-using-msys2)
- [Set Up Your Environment](#set-up-your-environment)
- [Clone the Repository](#clone-the-repository)
- [Build the Project](#build-the-project)
- [Running the Game](#running-the-game)
- [Useful Resources](#useful-resources)
- [Who do I talk to?](#who-do-i-talk-to)

### Instructions for Linux
1. **Linux Raylib install deb distro desktop**
   - Install dependencies:
      ```bash
      chmod +x toolchain.sh
      chmod +x build_web.sh
      ```
    After cloning run `make`, which will run `toolchain.sh` which sets up all toolchain dependancies

   - Install dependencies "Guide Only" see `toolchain.sh`:
    This updates system and installs essential build tools
     ```bash
     sudo apt update
     sudo apt upgrade
     
     # Core build tools
     sudo apt install -y build-essential cmake
     
     # Audio libraries
     sudo apt install -y libasound2-dev libpulse-dev libopenal-dev
     
     # Graphics and rendering libraries
     sudo apt install -y libgl1-mesa-dev libegl1-mesa-dev libgbm-dev libdrm-dev libglfw3-dev
     
     # X Window system libraries
     sudo apt install -y libx11-dev libxcursor-dev libxi-dev libxrandr-dev
     ```
   - Download Raylib source:
    Download Raylib Repo
     ```bash
     git clone https://github.com/raysan5/raylib.git
     cd raylib
     ```
   - Build and Install Raylib:
    Raylib Build
     ```bash
     # create a build directory
     mkdir build
     cd build
     # Build Makefiles using cmake NOTE ..
     # cmake generates Makefiles
     cmake ..
     # Next build raylib
     make
     # Install Raylib system wide
     sudo make install
     ```
2. **Linux Raylib install deb distro web**
   - Download Emscripten source:
    Download Emscripten Repo
     ```bash
     git clone https://github.com/emscripten-core/emsdk.git
     cd emsdk
     ```
   - Build and Install Emscripten:
    Emscripten Build
     ```bash

     # Using brew install emsdk
     ./emsdk install latest
     ./emsdk activate latest
     
     # Setup enviroment variables
     source emsdk_env.sh
     
     # Switch to raylib directory
     # Make build directory
     cd raylib
     mkdir build_web
     cd build_web

     # Build Makefiles using cmake NOTE ..
     # cmake generates Makefiles
     emcmake cmake .. -DBUILD_EXAMPLES=OFF -DBUILD_GLFW=OFF -DUSE_WAYLAND=OFF -DUSE_X11=OFF -DPLATFORM=Web
     emmake make
     ```

### Instructions for Windows using MSYS2
1. **Install MSYS2**
   - Download MSYS2 from [msys2.org](https://www.msys2.org/).
   - Follow the installation instructions provided on the website.
   - During inital make runs MYSYS2 will be shutdown as it updates packages (pacman in particular). When this happens make sure to restart `ucrt64` MYSYS2 bash terminal.

2. **Update the Package Database**
   - Open the MSYS2 terminal and run:
     ```bash
     pacman -Syu
     ```
   - Close the terminal and reopen it.

3. **Install Necessary Packages**
   - Install the GCC compiler and make utility:
     ```bash
     pacman -s git
     pacman -S make
     pacman -S mingw-w64-ucrt-x86_64-gcc 
     pacman -S mingw-w64-ucrt-x86_64-raylib
     pacman -S python
     pacman -S mingw-w64-ucrt-x86_64-emscripten
     ```
   - Make sure to add MSYS2 to your system path to access the tools from anywhere.

## Set Up Your Environment

- Open the **MSYS2 MinGW 64-bit** terminal to ensure you are using the correct environment.

## Clone the Repository

- Navigate to your desired directory and clone the repository:

    ```bash
    git clone https://bitbucket.org/MuddyGames/raylib_starter.git
    cd raylib_starter
    ```

## Build the Project

- Run the `make` command to build the project:

    ```bash
    make all
    make clean
    make build_web
    make run_web
    ```

## Running the Game

- After building the project, you can run the game with the following command:

    ```bash
    ./bin/game
    ```

## Useful Resources ##
* [Raylib](https://www.raylib.com/)
* [Emscripten.org](https://emscripten.org/)

## Who do I talk to? ##
* muddygames