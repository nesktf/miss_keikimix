SOURCE_DIR := src
BUILD_DIR := build
LOVEFILE := $(BUILD_DIR)/miss_keikimix.love

.PHONY: all run

all: lovefile

run:
	love ./src

lovefile: $(LOVEFILE)

$(LOVEFILE):
	mkdir -p $(BUILD_DIR)
	cd $(SOURCE_DIR); zip -r -9 ../$(BUILD_DIR)/miss_keikimix.love .
