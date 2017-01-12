# Build tools
.PHONY: all watch install


# Watch
# NOTE On OSX, overwrite watch native command:
# brew install watch
# brew info watch # read watch path
# sudo mv <path_to_watch>/bin/watch /usr/local/bin
all: dist/styles/main.css dist/scripts/main.js dist/scripts/vendor.js

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
dist/styles/main.css: assets/styles/*.scss assets/styles/**/*.scss
	@ node-sass --output-style=compressed assets/styles/main.scss -o dist/styles/ --source-map dist/styles/
	@ echo "› $@ has been updated"

dist/scripts/main.js: assets/scripts/*.js
	@ uglifyjs assets/scripts/*.js -o dist/scripts/main.js --source-map dist/scripts/main.js.map -p relative
	@ echo "› $@ has been updated"

VENDOR = $(shell bower-files js)
dist/scripts/vendor.js: $(VENDOR)
ifeq ($(VENDOR), all)
	@ uglifyjs $(VENDOR) -o dist/scripts/vendor.js --source-map dist/scripts/vendor.js.map -p relative
	@ echo "› $@ has been updated"
endif



# Install dependencies
PACKAGES = "node-sass uglifyjs bower bower-files browser-sync imagemin-cli"
PATHS = "dist/styles dist/scripts"
docs = false
install:
	@ echo "› Checking NPM dependencies:"
	@ for name in "$(PACKAGES)"; do hash $$name 2>/dev/null || (echo "-- Installing $$name" && sudo npm install -g $$name); done
	@ echo "› Done. Installing frond-end dependencies:"
	@ bower install --allow-root
	@ echo "› Done. Creating folders:"
	@ for dir in "$(PATHS)";do mkdir -p $$dir && echo "$$dir created.";done
ifeq ($(docs), true)
	@ echo "› Building docs/ folder:"
	@ mkdir -p docs/
	@ cp -r dist docs/
	@ mv index.html README.md guidelines.md _coverpage.md docs/
endif
	@ echo "› Installation done, start with \"make watch\"."



# Build commands
# --------------------
.PHONY: build styles scripts fonts images

prod = false
build:
	@ make styles
	@ make scripts
	@ make fonts
	@ make images

styles:
	@ echo "› Building styles:"
	@ rm -rf dist/styles && mkdir -p dist/styles
	@ make dist/styles/bootstrap.css
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
	@ for dir in $$(find assets/images -type d);do mkdir -p dist/$${dir#*/} && echo dist/$${dir#*/} && imagemin $${dir}/* -o dist/$${dir#*/};done
	@ echo "› Done."
