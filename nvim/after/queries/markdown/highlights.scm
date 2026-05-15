; extends
; Recapture the blockquote markers (`>` and continuation `>`) so they
; inherit @markup.quote color instead of the default @punctuation.special.
([
  (block_quote_marker)
  (block_continuation)
] @markup.quote
  (#set! priority 105))
