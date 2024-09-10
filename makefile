version := 0.4.1

CHECK_FILE_SIZE= (\
	FSIZE=$$(du -b ./builds/13_blades_${version}.prod.zip | cut -f 1); \
	LEFTOVER=$$((13312 - $${FSIZE})); \
	echo "===>File size: [$${FSIZE}]; [$${LEFTOVER}] left"; \
    if [ $$FSIZE -lt 13312 ]; then \
		echo "===>Under 13k; good job!";\
	else\
		echo "===>Over 13k :( get to slimming";\
	fi)

build:
	advpng -z -4 -i 20 ./assets/*.png
	mkdir -p ./builds/tmp/scripts
	esbuild ./scripts/game.mjs --bundle --minify --format=iife --outfile=./builds/tmp/scripts/game.mjs
	zip -r ./builds/13_blades_${version}.prod.zip assets index.html
	env -C ${PWD}/builds/tmp zip -r -g ../13_blades_${version}.prod.zip ./scripts
	advzip -z -4 -i 20 ./builds/13_blades_${version}.prod.zip
	@$(CHECK_FILE_SIZE)
server:
	python3 -m http.server -b 127.0.0.1
