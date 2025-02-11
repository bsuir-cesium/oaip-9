run:
	@echo "\n\n---===---\nbuilding... \n---===---\n\n"
	fpc src/main.dpr -obin/main.o
	@echo "\n\n---===---\nbuild done \ntrying to run:\n---===---\n\n"
	./bin/main.o