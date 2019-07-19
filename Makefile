
BUILD=build

all: book.html

$(BUILD):
	mkdir -p $(BUILD)

%.html: %.md
	markdown $< > $@

$(BUILD)/book.md: book.lst
	cat `cat $<` > $@
