; extends
(
 ("unsafe") @accent
 (#set! "priority" 199)
)

(
 ("ref") @accent
 (#set! "priority" 199)
)

(
 (mutable_specifier) @accent
 (#set! "priority" 199)
)

(outer_doc_comment_marker) @comment.documentation
(inner_doc_comment_marker) @comment.documentation

(lifetime
  "'" @attribute)
