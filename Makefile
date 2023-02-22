app_name=AutoVPN
out_dir=AutoVPN.spoon
hammerspoon_dir=$$HOME/.hammerspoon

all: clean build package

brew-deps:
	brew install openssl@1.1

lua-deps:
	luarocks install lrexlib-PCRE2 PCRE2_DIR=/usr/local/Cellar/pcre2/10.40
	luarocks install otp OPENSSL_DIR=/usr/local/Cellar/openssl@1.1/1.1.1q CRYPTO_DIR=/usr/local/Cellar/openssl@1.1/1.1.1q

deps: brew-deps lua-deps

clean:
	rm -rf $(out_dir)
	rm -f Spoons/$(app_name).spoon.zip
	mkdir -p $(out_dir)

fmt:
	fnlfmt --fix *.fnl

build: AutoVPN

.PHONY: AutoVPN
AutoVPN:
	fennel --compile --require-as-include init.fnl > $(out_dir)/init.lua

package:
	zip -o Spoons/$(app_name).spoon.zip $(out_dir)/* $(out_dir)/**/*

install: build
	cp -R $(app_name).spoon $(hammerspoon_dir)/Spoons/

