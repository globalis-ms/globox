# General configuration
# --------------------
host = "http://localhost"
port = 3000
sync = true
local-modules = true
admin-cmd = 'sudo'
prod = false
docs = false

ifeq ($(local-modules), true)
	cmd-prefix = $(shell npm bin)/
else
	cmd-prefix = ''
endif

# Build tools
# --------------------
.PHONY: all watch install

all: dist/styles/main.css dist/scripts/main.js dist/scripts/vendor.js

# Watch
# NOTE On OSX, overwrite watch native command:
# brew install watch
# brew info watch # read watch path
# sudo mv <path_to_watch>/bin/watch /usr/local/bin
watch:
ifeq ($(sync), true)
	@ $(cmd-prefix)browser-sync start -p $(host) --port $(port) --files "index.html" "public" --no-open &> /dev/null | \
	watch -t -n 1 "make all && echo '-- Browser-sync listening on $(host):$(port)'"
else
	@ watch -t -n 1 make all
endif

# Concat & minify styles & scripts
dist/styles/main.css: assets/styles/*.scss assets/styles/**/*.scss
	@ $(cmd-prefix)node-sass --output-style=compressed assets/styles/main.scss -o dist/styles/ --source-map dist/styles/
	@ echo "› $@ has been updated"

dist/scripts/main.js: assets/scripts/*.js
	@ $(cmd-prefix)uglifyjs assets/scripts/*.js -o dist/scripts/main.js --source-map dist/scripts/main.js.map -p relative
	@ echo "› $@ has been updated"

dist/scripts/vendor.js: $(VENDOR)
VENDOR = $(shell $(cmd-prefix)bower-files js)
ifeq ($(VENDOR), all)
	@ $(cmd-prefix)uglifyjs $(VENDOR) -o dist/scripts/vendor.js --source-map dist/scripts/vendor.js.map -p relative
	@ echo "› $@ has been updated"
endif

# Install dependencies
install:
	@ echo "› Checking NPM dependencies:"
ifeq ($(local-modules), true)
	@ npm install
else
	@ $(admin-cmd) npm install -g
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
.PHONY: build styles scripts fonts images

build:
	@ make styles
	@ make scripts
	@ make fonts
	@ make images

styles:
	@ echo "› Building styles:"
	@ rm -rf dist/styles && mkdir -p dist/styles
	@ make dist/styles/main.css
ifeq ($(prod), true)
	@ cat dist/styles/*.css > dist/styles/build.css
endif
	@ echo "› Done."

scripts:
	@ echo "› Building scripts:"
	@ rm -rf dist/scripts && mkdir -p dist/scripts
	@ make dist/scripts/main.js
	@ make dist/scripts/vendor.js
ifeq ($(prod), true)
	@ cat dist/scripts/*.js > dist/styles/build.js
endif
	@ echo "› Done."

fonts:
	@ echo "› Moving fonts:"
	@ rm -rf dist/fonts
	cp -r assets/fonts dist
	@ echo "› Done."

images:
	@ echo "› Optimizing images:"
	@ rm -rf dist/images
	@ for dir in $$(find assets/images -type d);do mkdir -p dist/$${dir#*/} && echo dist/$${dir#*/} && $(cmd-prefix)imagemin $${dir}/* -o dist/$${dir#*/};done
	@ echo "› Done."
