# Build tools
# Read: http://west.io/post/2015/04/11-frontend-builds-with-makefiles/
.PHONY: all watch install


# Watch
# NOTE On OSX, overwrite watch native command:
# brew install watch
# brew info watch # read watch path
# sudo mv <path_to_watch>/bin/watch /usr/local/bin
all: dist/styles/main.css dist/scripts/main.js

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
dist/styles/main.css: sources/styles/*.scss sources/styles/**/*.scss ../globox/styles/*.scss
	@ node-sass --output-style=compressed sources/styles/main.scss -o dist/styles/ --source-map dist/styles/
	@ echo "› $@ has been updated"

dist/scripts/main.js: sources/scripts/*.js
	@ uglifyjs sources/scripts/*.js -o dist/scripts/main.js --source-map dist/scripts/main.js.map -p relative
	@ echo "› $@ has been updated"



# Install dependencies
PACKAGES = "node-sass uglifyjs browser-sync"
install:
	@ echo "› Checking NPM dependencies:"
	@ for name in "$(PACKAGES)"; do hash $$name 2>/dev/null || (echo "-- Installing $$name" && sudo npm install -g $$name); done
	@ mkdir -p dist/styles dist/scripts
	@ echo "› Installation done, start with \"make watch\"."
