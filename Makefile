# Include custom message printing
include toolchain/messages.mk

# Compiler
CC						:= g++

# Silence command echoing
.SILENT:

# Messages
MSG_BUILD_START			:= "Game binary Build Started..."
MSG_BUILD_END			:= "Game binary Build Complete..."
MSG_BUILD_WEB_FAIL		:= "Game binary Build error..."
MSG_CLEAN				:= "Cleaning up..."
MSG_CLEAN_TOOLCHAIN		:= "Cleaning Toolchain..."
MSG_RUN_BINARY			:= "Running Game binary..."
MSG_BUILD_WEB_START		:= "Starting WEB Build..."
MSG_BUILD_WEB_END		:= "WEB Build Complete..."
MSG_BUILD_WEB_FAIL		:= "Game Web Build error..."
MSG_SERVER_CHECK		:= "Check if server is running..."
MSG_SERVER_STOP			:= "Stopping server..."
MSG_SERVER_START		:= "Starting server..."
MSG_TOOLCHAIN_NO_SCRIPT	:= "Required toolchain script not found. Reclone and check for script..."
MSG_TOOLCHAIN_SCRIPT	:= "Required toolchain script found. Installing Toolchain..."
MSG_TOOLCHAIN_NONE		:= "Required toolchain not found. Installing Toolchain..."
MSG_TOOLCHAIN_FOUND		:= "Required toolchain found. Skipping toolchain setup..."
MSG_RAYLIB_NONE			:= "Raylib package not found. Running toolchain script..."
MSG_RAYLIB_FOUND		:= "Raylib package found. Skipping toolchain setup..."
MSG_EMSDK_NONE			:= "emsdk package not found. Running toolchain script..."
MSG_EMSDK_FOUND			:= "emsdk package found. Skipping toolchain setup..."

# Directories
BUILD_DIR				:= ./bin
SRC_DIR					:= ./src
WEB_DIR					:= ./web
RAYLIB_DIR				:= ./raylib
RAYLIB_INC				:= $(RAYLIB_DIR)/src
RAYLIB_LIB				:= $(RAYLIB_DIR)/build/raylib
RAYLIB_LIB_WEB			:= $(RAYLIB_DIR)/build_web/raylib
EMSDK_DIR				:= ./emsdk
INCLUDE_DIR             := ./include

# Game HTML Template
HTML_TEMPLATE			:= ./template/template.html

# Default build type
BUILD_TYPE				:= "all"
BUILD					:= "build"
BUILD_WEB				:= "build_web"

# OS detection
IS_WINDOWS				:= FALSE
IS_LINUX				:= FALSE
IS_WSL					:= FALSE
IS_MACOS				:= FALSE

UNAME_S					:= $(shell uname -s)

IS_WINDOWS				:= $(if $(findstring MINGW,$(UNAME_S)),TRUE,FALSE)
IS_LINUX				:= $(if $(findstring Linux,$(UNAME_S)),TRUE,FALSE)
IS_WSL					:= $(shell grep -qi Microsoft /proc/version && echo TRUE || echo FALSE)
IS_MACOS				:= $(if $(findstring Darwin,$(UNAME_S)),TRUE,FALSE)

# Set TOOLCHAIN based on the platform
ifeq ($(IS_WINDOWS),TRUE)
	TOOLCHAIN			:= ./toolchain/toolchain_windows.sh
else ifeq ($(IS_MACOS),TRUE)
	TOOLCHAIN			:= ./toolchain/toolchain_macos.sh
	CXX					:= clang
else
	TOOLCHAIN			:= ./toolchain/toolchain_linux.sh
endif

# Platform-specific variables
ifeq ($(IS_WINDOWS),TRUE)
	# Windows-specific settings
	# Attempt to set MSYS2_PATH using MSYSTEM_PREFIX or fallback to C:/msys64/$(MSYSTEM)
	MSYS2_PREFIX        := $(shell cygpath -u "$$MSYSTEM_PREFIX")
	ifeq ($(MSYS2_PREFIX),)
		# Fallback if MSYSTEM_PREFIX is not set
		MSYS2_PATH		:= $(shell cygpath -u "C:/msys64/$(MSYSTEM)")
		ifeq ($(wildcard $(MSYS2_PATH)),)
			$(error "MSYS2 path not found in fallback location. Please ensure MSYS2 is installed.")
		endif
	else
		MSYS2_PATH      := $(MSYS2_PREFIX)
	endif

	INCLUDES			:= -I$(MSYS2_PATH)/include -I. -I./raylib/src -I$(MSYS2_PATH)/include/GLFW -I$(INCLUDE_DIR)
	LIBS				:= -L$(MSYS2_PATH)/lib -L./raylib/build/raylib -L$(MSYS2_PATH)/lib
	LIBRARIES			:= -lraylib -lglfw3 -lopengl32 -lgdi32 -lm -lpthread -lwinmm
	TARGET				:= $(BUILD_DIR)/game.exe
	WEB_APP				:= start http://localhost:8000/

else ifeq ($(IS_MACOS),TRUE)
	# macOS-specific settings
	INCLUDES			:= -I. -I$(RAYLIB_INC) -I$(INCLUDE_DIR)
	LIBS				:= -L.
	LIBRARIES			:= -lraylib -framework OpenGL -framework Cocoa
	TARGET				:= $(BUILD_DIR)/game.bin
	WEB_APP				:= open http://localhost:8000/

else ifeq ($(IS_WSL),TRUE)
	# WSL settings
	INCLUDES			:= -I. -I$(RAYLIB_INC) -I$(INCLUDE_DIR)
	LIBS				:= -L.
	LIBRARIES			:= -lraylib -lGL -lm -lpthread -ldl
	TARGET				:= $(BUILD_DIR)/game.bin
	WEB_APP				:= wslview http://localhost:8000/

else
	# Linux settings
	INCLUDES			:= -I. -I$(RAYLIB_INC) -I$(INCLUDE_DIR)
	LIBS				:= -L.
	LIBRARIES			:= -lraylib -lGL -lm -lpthread -ldl
	TARGET				:= $(BUILD_DIR)/game.bin
	WEB_APP				:= xdg-open http://localhost:8000/
endif

CFLAGS					:= -std=c++11 -Wall -Wextra -Werror -g $(INCLUDES)
LIBRARIES_WEB			:= -lraylib
WEB_TARGET				:= $(WEB_DIR)/index.html

# Source files
SRC						:= $(wildcard $(SRC_DIR)/*.cpp)

# Default target
.PHONY: all
all: build run

# Build target
.PHONY: build
build: BUILD_TYPE := build
build: install_toolchain
	$(call INFO_MSG,$(MSG_BUILD_START))
	rm -rf $(BUILD_DIR) && mkdir -p $(BUILD_DIR) && \
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC) $(LIBS) $(LIBRARIES)
	$(call SUCCESS_MSG,$(MSG_BUILD_END))

# Run target
.PHONY: run
run:
	$(call INFO_MSG,$(MSG_RUN_BINARY))
	./$(TARGET)

# Web build target
.PHONY: build_web
build_web: BUILD_TYPE := build_web
build_web: install_toolchain
	$(call INFO_MSG,$(MSG_BUILD_WEB_START))
	rm -rf $(WEB_DIR)
	mkdir -p $(WEB_DIR)

	# Execute build script and capture exit status
	@bash ./toolchain/build_web.sh $(RAYLIB_INC) $(RAYLIB_LIB_WEB) $(EMSDK_DIR) $(HTML_TEMPLATE); \
	exit_status=$$?; \
	if [ $$exit_status -ne 0 ]; then \
	    $(call ERROR_MSG,$(MSG_BUILD_WEB_FAIL)); \
	else \
	    $(call SUCCESS_MSG,$(MSG_BUILD_WEB_END)); \
	fi

# Run Web target
.PHONY: run_web
run_web: build_web install_toolchain stop_web_server stop_web_server start_web_server
	$(WEB_APP)

# Stop Web Server target
stop_web_server:
	$(call INFO_MSG,$(MSG_SERVER_CHECK))
	PID=$$(ps aux | grep '[h]ttp.server' | awk '{print $$2}'); \
	if [ -n "$$PID" ]; then \
    	kill $$PID; \
	fi

# Start Web Server target
start_web_server:
	$(call INFO_MSG,$(MSG_SERVER_START))
	python3 -m http.server --directory $(WEB_DIR) &
	sleep 3
	$(WEB_APP)

# Install toolchain target
install_toolchain:
	$(info BUILD_TYPE: $(BUILD_TYPE))
	$(info TARGET: $(TARGET))
	$(info TARGET: $(TOOLCHAIN))

	# Check if the TOOLCHAIN file exists
	if [ ! -f "$(TOOLCHAIN)" ]; then \
		$(call ERROR_MSG,$(MSG_TOOLCHAIN_NO_SCRIPT)); \
		exit 1; \
	else \
		$(call INFO_MSG,$(MSG_TOOLCHAIN_SCRIPT)); \
	fi

	# Check if raylib is installed
	if [ -d "$(RAYLIB_DIR)" ]; then \
		$(call INFO_MSG,$(MSG_TOOLCHAIN_FOUND)); \
		$(call SUCCESS_MSG,$(MSG_RAYLIB_FOUND)); \
	else \
		$(call INFO_MSG,$(MSG_TOOLCHAIN_NOT_FOUND)); \
		$(call INFO_MSG,$(MSG_TOOLCHAIN_NONE)); \
		$(call WARNING_MSG,$(MSG_RAYLIB_NONE)); \
		$(TOOLCHAIN) $$(pwd) "$(BUILD)"; \
	fi

	# Check if emsdk is installed and build type is build_web
	if [ "$(BUILD_TYPE)" = "$(BUILD_WEB)" ]; then \
		if [ -d "$(EMSDK_DIR)" ]; then \
			$(call INFO_MSG,$(MSG_TOOLCHAIN_FOUND)); \
			$(call SUCCESS_MSG,$(MSG_EMSDK_FOUND)); \
			EMSDK_INSTALLED=1; \
		else \
			$(call INFO_MSG,$(MSG_TOOLCHAIN_NOT_FOUND)); \
			$(call INFO_MSG,$(MSG_TOOLCHAIN_NONE)); \
			$(call WARNING_MSG,$(MSG_EMSDK_NONE)); \
			$(TOOLCHAIN) $$(pwd) "$(BUILD_WEB)"; \
		fi; \
	fi

# Clean target
.PHONY: clean
clean:
	$(call INFO_MSG,$(MSG_CLEAN))
	rm -rf $(BUILD_DIR) $(WEB_DIR)

# Clean target
.PHONY: clean_toolchain
clean_toolchain:
	$(call INFO_MSG,$(MSG_CLEAN_TOOLCHAIN))
	rm -rf $(RAYLIB_DIR) $(EMSDK_DIR)
