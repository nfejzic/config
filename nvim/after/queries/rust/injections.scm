; extends

(
    (string_content) @injection.content
    (#match? @injection.content "^[ \t\n]*(CREATE|SELECT|INSERT|UPDATE|DELETE|WITH|USE|DROP|ALTER|SET).*")
    (#set! injection.language "sql")
)
