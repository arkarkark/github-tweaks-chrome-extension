CSON_FILES = $(wildcard *.cson)
COFFEE_FILES = $(wildcard *.coffee)
ICONS=icon128.png icon48.png icon16.png
ZIP_EXCLUDE= $(CSON_FILES) $(COFFEE_FILES) .git* octocat-shades.png screenshot*.png Makefile README.md


JSON_FILES = $(CSON_FILES:.cson=.json)
JS_FILES = $(COFFEE_FILES:.coffee=.js)

space :=
space +=
ZIP_EXCLUDE_FLAGS = --exclude=$(subst $(space),$(space)--exclude=,$(ZIP_EXCLUDE))

build: $(wildcard **/*) $(ICONS) $(JSON_FILES) $(JS_FILES)
	dirname=$(shell basename $(PWD)); zip -r $(ZIP_EXCLUDE_FLAGS) ../$$dirname.zip .

clean:
	rm -fv $(JSON_FILES) $(JS_FILES) $(ICONS)

%.json : %.cson
	cson2json $< > $@

%.js : %.coffee
	coffee -p $< > $@

icon%.png: octocat-shades.png
	convert octocat-shades.png -resize $* $@
