# platform.mk — single source of platform detection for all modules.
# macOS (incl. Apple Silicon) and Linux are supported.
# Tools themselves are managed by mise, so arch is handled there —
# only paths that genuinely differ per-OS live here.

OS ?= $(shell uname -s)

ifeq ($(OS),Darwin)
FONT_DIR := $(HOME)/Library/Fonts
FONTCACHE ?=
else
FONT_DIR := $(XDG_DATA_HOME)/fonts
FONTCACHE ?= fc-cache -vf
endif