build: $(wildcard **/*)
	dirname=$(shell basename $(PWD)); zip -r --exclude=.git* ../$$dirname.zip .
