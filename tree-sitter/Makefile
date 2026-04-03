PARSERS := \
	parsers/go.so \
	parsers/sql.so

all: $(PARSERS)

parsers/go.so: tree-sitter-go/src/parser.c
	@mkdir -p parsers
	$(CC) -shared -fPIC -o $@ -I $(<D) $< $(wildcard tree-sitter-go/src/scanner.c) -O2

parsers/sql.so: tree-sitter-sql/src/parser.c
	@mkdir -p parsers
	$(CC) -shared -fPIC -o $@ -I $(<D) $< $(wildcard tree-sitter-sql/src/scanner.c) -O2

clean:
	rm -rf parsers

.PHONY: all clean
