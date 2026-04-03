GRAMMARS := $(wildcard tree-sitter-*/src/parser.c)
PARSERS  := $(patsubst tree-sitter-%/src/parser.c,parsers/%.so,$(GRAMMARS))

all: $(PARSERS)

parsers/%.so: tree-sitter-%/src/parser.c
	@mkdir -p parsers
	$(CC) -shared -fPIC -o $@ -I $(<D) $< $(wildcard tree-sitter-$*/src/scanner.c) -O2

clean:
	rm -rf parsers

.PHONY: all clean
