; extends
; GitHub-style callouts: > [!NOTE], > [!TIP], etc. Highlight group names use
; the conventional dotted form; the ftplugin defines them.
; Priority 105 beats the default 100 of @markup.link.label.

((shortcut_link
  (link_text) @_tag) @markup.callout.note
  (#eq? @_tag "!NOTE")
  (#set! priority 105))

((shortcut_link
  (link_text) @_tag) @markup.callout.tip
  (#eq? @_tag "!TIP")
  (#set! priority 105))

((shortcut_link
  (link_text) @_tag) @markup.callout.important
  (#eq? @_tag "!IMPORTANT")
  (#set! priority 105))

((shortcut_link
  (link_text) @_tag) @markup.callout.warning
  (#eq? @_tag "!WARNING")
  (#set! priority 105))

((shortcut_link
  (link_text) @_tag) @markup.callout.caution
  (#eq? @_tag "!CAUTION")
  (#set! priority 105))

; Strip the chip background from the backticks of inline code so only the
; inner text shows the highlight.
((code_span_delimiter) @markup.raw.delimiter
  (#set! priority 105))
