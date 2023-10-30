; extends
(pair
    key: (property_identifier) @_key (#eq? @_key "sql")
    value: (template_string) @sql
    (#offset! @sql 0 1 0 -1)
)

; Use this one if tagged template string is used, e.g. mysql`SELECT ...`
(pair
    key: (property_identifier) @_key (#eq? @_key "sql")
    value: (call_expression
                function: (identifier)
                arguments: (template_string) @sql
                (#offset! @sql 0 1 0 -1)
           ) 
)

(call_expression
    function: (identifier) @mysql_fn (#eq? @mysql_fn "mysql")
    arguments: (template_string) @sql
    (#offset! @sql 0 1 0 -1)
)
