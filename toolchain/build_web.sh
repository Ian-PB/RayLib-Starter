#!/bin/bash

# Message functions
source ./toolchain/messages.sh

# Check if RAYLIB_INC is provided
if [ -z "$1" ]; then
    error_msg "Error: RAYLIB_INC is missing. Usage: $0 <RAYLIB_INC> <RAYLIB_LIB_WEB> <EMSDK_DIR> <html_template>"
    exit 1
fi

# Check if RAYLIB_LIB_WEB is provided
if [ -z "$2" ]; then
    error_msg "Error: RAYLIB_LIB_WEB is missing. Usage: $0 <RAYLIB_INC> <RAYLIB_LIB_WEB> <EMSDK_DIR> <html_template>"
    exit 1
fi

# Check if EMSDK_DIR is provided
if [ -z "$3" ]; then
    error_msg "Error: EMSDK_DIR is missing. Usage: $0 <RAYLIB_INC> <RAYLIB_LIB_WEB> <EMSDK_DIR> <html_template>"
    exit 1
fi

# Check if HTML_TEMPLATE is provided
if [ -z "$4" ]; then
    error_msg "Error: HTML_TEMPLATE is missing. Usage: $0 <RAYLIB_INC> <RAYLIB_LIB_WEB> <EMSDK_DIR> <HTML_TEMPLATE>"
    exit 1
fi

# Location of Raylib Include
RAYLIB_INC=$1

# Location of Raylib Web Lib
RAYLIB_LIB_WEB=$2

# Location of EMSDK
EMSDK_DIR=$3

# Location of Template
HTML_TEMPLATE=$4

# Set up the Emscripten environment
# Set up the Emscripten environment
info_msg "Setting up Emscripten environment..."

# Check if the emsdk_env.sh file exists
if [ -f "${EMSDK_DIR}/emsdk_env.sh" ]; then
    source "${EMSDK_DIR}/emsdk_env.sh"
    success_msg "Emscripten environment paths set up successfully."
else
    error_msg "Emscripten environment path setup script not found at ${EMSDK_DIR}/emsdk_env.sh. Please ensure Emscripten SDK is installed!"
    exit 1
fi

# Check if emcc is available
info_msg "Checking for emcc..."

if ! command -v emcc &> /dev/null; then
    error_msg "emcc not found. Please ensure Emscripten SDK is installed!"
    exit 1
else
    success_msg "emcc compiler found."
fi


# Build the web application
info_msg "Building the web application..."

if emcc ./src/main.cpp -o ./web/index.html \
    -I. -I${RAYLIB_INC} \
    -L${RAYLIB_LIB_WEB} \
    -lraylib \
    -s USE_GLFW=3 -s FULL_ES2=1 -s ASYNCIFY --shell-file ${HTML_TEMPLATE}; then
    success_msg "Web application built successfully."
else
    error_msg "Failed to build the web application."
    exit 1
fi

