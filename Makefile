build: $(wildcard **/*) icons
	dirname=$(shell basename $(PWD)); zip -r \
	--exclude=.git* --exclude=octocat-shades.png --exclude=screenshot*.png --exclude=*.{coffee,cson} \
	--exclude=Makefile --exclude=README.md \
	../$$dirname.zip .

icons: icon128.png icon48.png icon16.png

icon128.png: octocat-shades.png
	convert octocat-shades.png -resize 128 icon128.png

icon48.png: octocat-shades.png
	convert octocat-shades.png -resize 128 icon48.png

icon16.png: octocat-shades.png
	convert octocat-shades.png -resize 128 icon16.png
