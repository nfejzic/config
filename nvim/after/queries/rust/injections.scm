; extends

(
    (string_content) @injection.content
    (#match? @injection.content "^[ \t\n]*(CREATE|SELECT|INSERT|UPDATE|DELETE|WITH|USE|DROP|ALTER|SET).*")
    (#set! injection.language "sql")
)

; NOTE: this makes treesitter very slow...
; (
;     (line_comment (doc_comment) @_first)
;     (line_comment (doc_comment) @injection.content)+
;     (line_comment (doc_comment) @_last)
;     (#match? @_first "```(rust|ignore.*|should_panic|no_run|compile_fail|edition.*)?$")
;     (#match? @_last "```$")
;     (#set! injection.language "rust")
;     (#set! injection.combined)
; )
;
