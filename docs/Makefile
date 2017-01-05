# Build tools
.PHONY: all watch install


# Watch
# NOTE On OSX, overwrite watch native command:
# brew install watch
# brew info watch # read watch path
# sudo mv <path_to_watch>/bin/watch /usr/local/bin
all: assets/globox.css assets/globox.js

host = "http://localhost"
port = 3000
sync = true
watch:
ifeq ($(sync), true)
	@ browser-sync start -p $(host) --port $(port) --files "index.html" "public" --no-open &> /dev/null | \
	watch -t -n 1 "make all && echo '-- Browser-sync listening on $(host):$(port)'"
else
	@ watch -t -n 1 make all
endif


# Concat & minify styles & scripts
assets/globox.css: ../globox/styles/*.scss ../globox/styles/**/*.scss
	@ node-sass --output-style=compressed ../globox/styles/globox.scss -o assets/
	@ echo "› $@ has been updated"

assets/globox.js: ../globox/scripts/*.js
	@ uglifyjs ../globox/scripts/*.js -o $@
	@ echo "› $@ has been updated"



# Install dependencies
PACKAGES = "node-sass uglifyjs browser-sync"
install:
	@ echo "› Checking NPM dependencies:"
	@ for name in "$(PACKAGES)"; do hash $$name 2>/dev/null || (echo "-- Installing $$name" && sudo npm install -g $$name); done
	@ mkdir -p assets
	@ echo "› Installation done, start with \"make watch\"."
