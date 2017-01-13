# General configuration
# --------------------
# constants
NPM_GLOBAL = $(shell if [ -d "node_modules" ]; then echo "false"; else echo "true"; fi)
ifeq ($(NPM_GLOBAL), true)
	NPM_PREFIX = ''
else
	NPM_PREFIX = 'node_modules/.bin/'
endif

# browser-sync
host = "http://localhost"
port = 3000
sync = true

# install
global = false
docs = false



# Dev tools
# --------------------
.PHONY: all watch install

all: dist/styles/main.css dist/scripts/main.js

# Watch
# NOTE On OSX, overwrite watch native command:
# brew install watch
# brew info watch # read watch path
# sudo mv <path_to_watch>/bin/watch /usr/local/bin
watch:
ifeq ($(sync), true)
	@ $(NPM_PREFIX)browser-sync start -p $(host) --port $(port) --files "index.html" "public" --no-open &> /dev/null | \
	watch -t -n 1 "make all && echo '-- Browser-sync listening on $(host):$(port)'"
else
	@ watch -t -n 1 make all
endif

# Concat & minify styles & scripts
dist/styles/main.css: assets/styles/*.scss assets/styles/**/*.scss
	@ $(NPM_PREFIX)node-sass --output-style=compressed assets/styles/main.scss -o dist/styles/ --source-map dist/styles/
	@ echo "› $@ has been updated"

dist/scripts/main.js: assets/scripts/*.js
	@ $(NPM_PREFIX)uglifyjs assets/scripts/*.js -o dist/scripts/main.js --source-map dist/scripts/main.js.map -p relative
	@ echo "› $@ has been updated"

# Install dependencies
install:
ifeq ($(global), true)
	@ echo "› Global mode: make sure NPM dependencies are installed globally (check package.json)."
else
	@ echo "› Checking NPM dependencies:"
	@ npm install
endif
	@ echo "› Done. Installing frond-end dependencies:"
	@ bower install --allow-root
	@ echo "› Done. Creating folders:"
	@ for dir in "dist/styles" "dist/scripts";do mkdir -p $$dir && echo "$$dir created.";done
ifeq ($(docs), true)
	@ echo "› Building docs/ folder:"
	@ mkdir -p docs/
	@ cp -r dist docs/
	@ mv index.html README.md guidelines.md _coverpage.md docs/
else
	@ rm -f index.html README.md guidelines.md _coverpage.md
endif
	@ echo "› Installation done, start with \"make watch\"."



# Build commands
# --------------------
.PHONY: build styles scripts vendor fonts images

build:
	@ make styles
	@ make scripts
	@ make fonts
	@ make images

styles:
	@ echo "› Building styles:"
	@ rm -rf dist/styles && mkdir -p dist/styles
	@ make dist/styles/main.css
	@ echo "› Done."

scripts:
	@ echo "› Building scripts:"
	@ rm -rf dist/scripts && mkdir -p dist/scripts
	@ make dist/scripts/main.js
	@ make vendor
	@ echo "› Done."

vendor:
	@ echo "› Building vendor scripts:"
	@ $(NPM_PREFIX)uglifyjs $(shell $(NPM_PREFIX)bower-files js) -o dist/scripts/vendor.js --source-map dist/scripts/vendor.js.map -p relative
	@ echo "› dist/scripts/vendor.js has been updated"

fonts:
	@ echo "› Moving fonts:"
	@ rm -rf dist/fonts
	cp -r assets/fonts dist
	@ echo "› Done."

images:
	@ echo "› Optimizing images:"
	@ rm -rf dist/images
	@ for dir in $$(find assets/images -type d);do mkdir -p dist/$${dir#*/} && echo dist/$${dir#*/} && $(NPM_PREFIX)imagemin $${dir}/* -o dist/$${dir#*/};done
	@ echo "› Done."
