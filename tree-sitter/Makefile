PARSERS := \
	parsers/go.so \
	parsers/gotmpl.so \
	parsers/html.so \
	parsers/json.so \
	parsers/sql.so

all: $(PARSERS)

parsers/go.so: tree-sitter-go/src/parser.c
	@mkdir -p parsers
	$(CC) -shared -fPIC -o $@ -I $(<D) $< $(wildcard tree-sitter-go/src/scanner.c) -O2

parsers/gotmpl.so: tree-sitter-go-template/src/parser.c
	@mkdir -p parsers
	$(CC) -shared -fPIC -o $@ -I $(<D) $< $(wildcard tree-sitter-go-template/src/scanner.c) -O2

parsers/html.so: tree-sitter-html/src/parser.c
	@mkdir -p parsers
	$(CC) -shared -fPIC -o $@ -I $(<D) $< $(wildcard tree-sitter-html/src/scanner.c) -O2

parsers/json.so: tree-sitter-json/src/parser.c
	@mkdir -p parsers
	$(CC) -shared -fPIC -o $@ -I $(<D) $< $(wildcard tree-sitter-json/src/scanner.c) -O2

parsers/sql.so: tree-sitter-sql/src/parser.c
	@mkdir -p parsers
	$(CC) -shared -fPIC -o $@ -I $(<D) $< $(wildcard tree-sitter-sql/src/scanner.c) -O2

clean:
	rm -rf parsers

.PHONY: all clean
