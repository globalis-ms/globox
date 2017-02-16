# General configuration
# --------------------

# Phony targets
.PHONY: all build install fonts images scripts scripts_specific styles styles_specific watch

# Prefix for all commands using Node.js modules binaries
# Keep it empty if you prefer to use global modules
NPM_PREFIX = 'node_modules/.bin/'

# Determines if documentation files should be saved after installation
KEEP_DOCS = false

# Browser-sync configuration
host = "http://localhost"
port = 3000
sync = true


# Build commands
# --------------------

# Install and build command
all:
	@ make install
	@ make build

# Install Node.js modules, install bower dependencies, build documentation (if KEEP_DOCS is set to true)
install:
ifeq ($(global), true)
	@ echo "› Global mode: make sure NPM dependencies are installed globally (check package.json)."
else
	@ echo "› Checking NPM dependencies:"
	@ npm install
endif
	@ echo "› Installing front-end dependencies:"
	@ bower install --allow-root
ifeq ($(KEEP_DOCS), true)
	@ echo "› Building docs/ folder:"
	@ mkdir -p docs/
	@ cp -r dist docs/
	@ mv index.html README.md guidelines.md cover.md docs/
else
	@ echo "› Remove doc"
	@ rm -f index.html guidelines.md cover.md
endif
	@ echo "› Installation done, start with \"make watch\"."

# Build all assets into dist
build:
	@ echo "› Building everything..."
	@ make fonts
	@ make images
	@ make scripts
	@ make vendor
	@ make styles
	@ date +%Y%m%d%H%M%S > dist/version

# Copy fonts into dist
fonts:
	@ echo "› Moving fonts:"
	@ rm -rf dist/fonts && mkdir -m 777 -p dist/fonts
	cp -r assets/fonts dist
	@ echo "› Done."

# Optimize images and copy them into dist
images:
	@ echo "› Optimizing images:"
	@ rm -rf dist/images && mkdir -m 777 -p dist/images
	@ for dir in $$(find assets/images -type d);do mkdir -m 777 -p dist/$${dir#*/} && echo dist/$${dir#*/} && $(NPM_PREFIX)imagemin $${dir}/* -o dist/$${dir#*/};done
	@ echo "› Done."

# Minify, compile and copy main scripts into dist
scripts:
	@ echo "› Building scripts:"
	@ rm -rf dist/scripts && mkdir -m 777 -p dist/scripts/cache
	@ make dist/scripts/main.js
	@ echo "› Done."

# Minify, compile and copy vendor scripts into dist
vendor:
	@ echo "› Building vendor scripts:"
	@ $(eval files=$(shell $(NPM_PREFIX)bower-files js))
	@ [ -z "$(files)" ] || $(NPM_PREFIX)uglifyjs $(files) -o dist/scripts/vendor.js --source-map dist/scripts/vendor.js.map -p relative
	@ [ -z "$(files)" ] && echo "› no vendor scripts" || echo "› dist/scripts/vendor.js has been updated"
	@ echo "› Done."

# Minify, compile and copy main styles into dist
styles:
	@ echo "› Building styles:"
	@ rm -rf dist/styles && mkdir -m 777 -p dist/styles/cache
	@ make dist/styles/main.css
	@ echo "› Done."

# Watch changes on main scripts and styles files
# NOTE On OSX, overwrite watch native command:
# brew install watch
# brew info watch # read watch path
# sudo mv <path_to_watch>/bin/watch /usr/local/bin
watch:
ifeq ($(sync), true)
	@ $(NPM_PREFIX)browser-sync start -p $(host) --port $(port) --files "index.html" "public" --no-open &> /dev/null | \
	watch -t -n 1 "make dist/styles/main.css dist/scripts/main.js && echo '-- Browser-sync listening on $(host):$(port)'"
else
	@ watch -t -n 1 make dist/styles/main.css dist/scripts/main.js
endif


# Internal commands
# --------------------

# Concat & minify main styles
dist/styles/main.css: assets/styles/*.scss assets/styles/**/*.scss
	@ $(NPM_PREFIX)node-sass --output-style=compressed assets/styles/main.scss -o dist/styles/ --source-map dist/styles/
	@ echo "› $@ has been updated"

# Concat & minify main scripts
dist/scripts/main.js: assets/scripts/*.js
	@ $(NPM_PREFIX)uglifyjs assets/scripts/*.js -o dist/scripts/main.js --source-map dist/scripts/main.js.map -p relative
	@ echo "› $@ has been updated"