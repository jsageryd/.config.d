; SQL in string arguments to query functions,
; e.g. db.Query(`SELECT ...`) or db.Exec("SELECT ...")
((call_expression
  function: (selector_expression field: (field_identifier) @_fn)
  arguments: (argument_list
    [(raw_string_literal (raw_string_literal_content) @injection.content)
     (interpreted_string_literal (interpreted_string_literal_content) @injection.content)]))
  (#any-of? @_fn "Query" "QueryRow" "Exec" "Prepare" "QueryContext" "ExecContext" "QueryRowContext" "PrepareContext")
  (#set! injection.language "sql"))

; SQL in strings declared as q or *Q,
; e.g. q := "SELECT ..." or insertQ := `INSERT ...`[1:]
((short_var_declaration
  left: (expression_list (identifier) @_name)
  right: (expression_list
    [(raw_string_literal (raw_string_literal_content) @injection.content)
     (interpreted_string_literal (interpreted_string_literal_content) @injection.content)
     (slice_expression operand: (raw_string_literal (raw_string_literal_content) @injection.content))]))
  (#match? @_name "^(q|.*Q)$")
  (#set! injection.language "sql"))

; SQL in strings assigned to q or *Q,
; e.g. q = "SELECT ..." or insertQ = `UPDATE ...`[1:]
((assignment_statement
  left: (expression_list (identifier) @_name)
  right: (expression_list
    [(raw_string_literal (raw_string_literal_content) @injection.content)
     (interpreted_string_literal (interpreted_string_literal_content) @injection.content)
     (slice_expression operand: (raw_string_literal (raw_string_literal_content) @injection.content))]))
  (#match? @_name "^(q|.*Q)$")
  (#set! injection.language "sql"))
