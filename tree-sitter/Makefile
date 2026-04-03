PARSERS := \
	parsers/go.so

all: $(PARSERS)

parsers/go.so: tree-sitter-go/src/parser.c
	@mkdir -p parsers
	$(CC) -shared -fPIC -o $@ -I $(<D) $< $(wildcard tree-sitter-go/src/scanner.c) -O2

clean:
	rm -rf parsers

.PHONY: all clean
