
include config.mk

.PHONY: all love linux windows mac push clean example

default: love

all: love linux windows mac

love:
	@echo "Creating love file..."
	rm -f release/$(GAME).love
	cd src; zip -9 -r ../release/$(GAME).love *.lua
	zip -9 -r release/$(GAME).love assets LICENSE README.md
	@echo "Done."

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
	@echo "Creating example..."
	rm -f example/example.love
	cd example/; zip -9 -r example.love *
	cd src/; zip -9 -r ../example/example.love *
	zip -9 -r example/example.love lib/
	for lib in anim9 autobatch log tick; do \
		mv lib/$$lib/$$lib.lua lib/$$lib/init.lua; \
		zip -9 -r example/example.love lib/$$lib/*; \
		mv lib/$$lib/init.lua lib/$$lib/$$lib.lua; \
	done
	@echo "Done."
