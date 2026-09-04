; extends

; The grammar has no notion of what precedes a format-patch's first
; `diff --git`: the mail headers, the commit message and the trailers all
; parse as (unrecognized), and any space-prefixed line, a hunk's unchanged
; lines among them, as (context). Upstream captures neither, so inside a
; markdown fence the layer below shows through and @markup.raw.block paints
; both as though they were code.
;
; They are not the same thing, though. A hunk's context lines are code, and
; read as plain text; the message wrapped around the patch is prose.
(context) @diff.context

; A hunk admits (unrecognized) too, for a line the grammar cannot place. That
; one is diff content and no part of any message, so it is left alone.
((unrecognized) @diff.message
  (#not-has-ancestor? @diff.message changes))
