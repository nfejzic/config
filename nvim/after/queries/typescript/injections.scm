; extends
(pair
    key: (property_identifier) @_key (#eq? @_key "sql")
    value: (template_string) @sql
    (#offset! @sql 0 1 0 -1)
)
