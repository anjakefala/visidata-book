
BUILD=build

all: $(BUILD)/book.html

$(BUILD):
	mkdir -p $(BUILD)

%.html: %.md
	markdown $< > $@

$(BUILD)/book.md: book.lst $(BUILD)
	cat `cat $<` > $@

clean:
	rm $(BUILD)/*
