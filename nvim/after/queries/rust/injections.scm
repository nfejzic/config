; extends

(call_expression
  function: (_
    path: _
    name: (identifier) @_query_ident (#any-of? @_query_ident "query" "query_as" "query_with" "query_as_with")
  )
  arguments: (arguments
            (string_literal) @sql (#offset! @sql 0 1 0 -1))
)

(call_expression
  function: (_
    path: _
    name: (identifier) @_query_ident (#any-of? @_query_ident "query" "query_as" "query_with" "query_as_with")
  )
  arguments: (arguments
               (raw_string_literal) @sql (#offset! @sql 0 3 0 -2))
)
