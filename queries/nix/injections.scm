;extends

; Inject language based on file extension in attribute path strings.
; Covers patterns like: environment.etc."name.lua".text = ''...''
;                       environment.etc."script.sh".source = ''...''

(binding
  attrpath: (attrpath
    (string_expression
      (string_fragment) @_key
      (#lua-match? @_key "%.lua$")))
  expression: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
  ]
  (#set! injection.combined))

(binding
  attrpath: (attrpath
    (string_expression
      (string_fragment) @_key
      (#lua-match? @_key "%.[Pp][Yy]$")))
  expression: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "python")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "python")))
  ]
  (#set! injection.combined))

(binding
  attrpath: (attrpath
    (string_expression
      (string_fragment) @_key
      (#lua-match? @_key "%.[Ss][Hh]$")))
  expression: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "bash")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "bash")))
  ]
  (#set! injection.combined))

(binding
  attrpath: (attrpath
    (string_expression
      (string_fragment) @_key
      (#lua-match? @_key "%.bash$")))
  expression: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "bash")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "bash")))
  ]
  (#set! injection.combined))

(binding
  attrpath: (attrpath
    (string_expression
      (string_fragment) @_key
      (#lua-match? @_key "%.fish$")))
  expression: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "fish")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "fish")))
  ]
  (#set! injection.combined))

(binding
  attrpath: (attrpath
    (string_expression
      (string_fragment) @_key
      (#lua-match? @_key "%.[cm]?js$")))
  expression: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "javascript")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "javascript")))
  ]
  (#set! injection.combined))
