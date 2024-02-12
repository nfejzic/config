; extends
; (call_expression
;   function: 
;     (selector_expression
;       operand: (_)
;       field: (field_identifier) @_query_f (#any-of? @_query_f "QueryRow" "Query" "Exec" "Get" "MustRunQuery"))
;   arguments: [(argument_list
;                 (interpreted_string_literal) @injection.content (#offset! @injection.content 0 1 0 -1))
;               (argument_list
;                 (raw_string_literal) @injection.content (#offset! @injection.content 0 0 0 0))
;              ]
;   (#set! injection.language "sql")
; )

; maybe easier one, checks all strings that contain some of sql keywords
(
  (raw_string_literal) @injection.content
    (#match? @injection.content "^`[ \t\n]*(SELECT|INSERT|UPDATE|DELETE|WITH|USE|DROP|ALTER|SET).*")
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "sql")
)

(
  (interpreted_string_literal) @injection.content
    (#match? @injection.content "^\"[ \t\n]*(SELECT|INSERT|UPDATE|DELETE|WITH|USE|DROP|ALTER|SET).*")
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "sql")
)
