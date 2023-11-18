; extends
(call_expression
    function: (selector_expression
        operand: (identifier)
        field: (field_identifier) @_query_f (#match? @_query_f "QueryRow")
    )
    arguments: [(argument_list
                 (interpreted_string_literal) @sql (#offset! @sql 0 1 0 1))
                (argument_list
                 (raw_string_literal) @sql (#offset! @sql 0 0 0 0))
               ]
    
)
