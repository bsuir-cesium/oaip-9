default: build run

build:
	@echo "\n\n---===---\nbuilding... \n---===---\n\n"
	fpc src/main.dpr -obin/main.o
	@echo "\n\n---===---\nbuild done \n---===---\n\n"

run:
	@echo "\n\n---===---\ntrying to run:\n---===---\n\n"
	./bin/main.o