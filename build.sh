#!/bin/sh

elm make src/Main.elm --output src/frontend/Main.js
uglifyjs src/frontend/Main.js src/frontend/init.js src/frontend/native.js --compress warnings=false --no-mangle > src/public/bundle.js
uglifycss src/frontend/main.css > src/public/bundle.css
minimize --output src/public/index.html src/frontend/index.html
