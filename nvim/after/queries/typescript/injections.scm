; extends

(
  (template_string
    (string_fragment) @injection.content
    (#match? @injection.content "^[ \t\n]*(SELECT|INSERT|UPDATE|DELETE|WITH|USE|DROP|ALTER|SET).*")
    (#set! injection.include-children)
    (#set! injection.language "sql")
  )
)

(
  (string) @injection.content
    (#match? @injection.content "^\"[ \t\n]*(SELECT|INSERT|UPDATE|DELETE|WITH|USE|DROP|ALTER|SET).*")
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.include-children)
    (#set! injection.language "sql")
) @sql
