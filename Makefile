
include config.mk

.PHONY: all love linux windows mac push clean example example2

default: love

all: love linux windows mac

love:
	@./build.sh $(GAME) release/$(GAME).love

linux:
	@echo "Building for linux..."
	cp release/$(GAME).love $(LINUX_NAME)
	@echo "Done."

windows:
	@echo "Building for Windows..."
	cat release/windows/love.exe release/$(GAME).love > $(WINDOWS_NAME)
	@echo "Done."

mac:
	@echo "Building for macOS..."
	cp release/$(GAME).love $(MAC_NAME)/Contents/Resources/
	@echo "Done."

push:
	@./butler.sh $(GAME) $(VERSION) $(ITCH) $(LINUX_PATH) $(WINDOWS_PATH) $(MAC_PATH)

clean: 
	rm -f release/$(GAME).love
	rm -f $(LINUX_NAME)
	rm -f $(WINDOWS_NAME)
	rm -f $(MAC_NAME)/Contents/Resources/$(GAME).love

example:
	@./build.sh example example/example.love

example2:
	@./build.sh example2 example2/example.love
