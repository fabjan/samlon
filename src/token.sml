structure Token =
struct

  datatype t =

  (* Single-character tokens. *)
    LEFT_PAREN
  | RIGHT_PAREN
  | LEFT_BRACE
  | RIGHT_BRACE
  | COMMA
  | DOT
  | MINUS
  | PLUS
  | SEMICOLON
  | SLASH
  | STAR

  (* One or two character tokens. *)
  | BANG
  | BANG_EQUAL
  | EQUAL
  | EQUAL_EQUAL
  | GREATER
  | GREATER_EQUAL
  | LESS
  | LESS_EQUAL

  (* Literals. *)
  | IDENTIFIER of string
  | STRING of string
  | NUMBER of real

  (* Keywords. *)
  | AND
  | CLASS
  | ELSE
  | FALSE
  | FUN
  | FOR
  | IF
  | NIL
  | OR
  | PRINT
  | RETURN
  | SUPER
  | THIS
  | TRUE
  | VAR
  | WHILE

  (* End of file. *)
  | EOF

  fun toString tok =
    case tok of
      LEFT_PAREN => "("
    | RIGHT_PAREN => ")"
    | LEFT_BRACE => "{"
    | RIGHT_BRACE => "}"
    | COMMA => ","
    | DOT => "."
    | MINUS => "-"
    | PLUS => "+"
    | SEMICOLON => ";"
    | SLASH => "/"
    | STAR => "*"
    | BANG => "!"
    | BANG_EQUAL => "!="
    | EQUAL => "="
    | EQUAL_EQUAL => "=="
    | GREATER => ">"
    | GREATER_EQUAL => ">="
    | LESS => "<"
    | LESS_EQUAL => "<="
    | IDENTIFIER s => "IDENTIFIER(" ^ s ^ ")"
    | STRING s => "STRING(" ^ s ^ ")"
    | NUMBER r => "NUMBER(" ^ Real.toString r ^ ")"
    | AND => "AND"
    | CLASS => "CLASS"
    | ELSE => "ELSE"
    | FALSE => "FALSE"
    | FUN => "FUN"
    | FOR => "FOR"
    | IF => "IF"
    | NIL => "NIL"
    | OR => "OR"
    | PRINT => "PRINT"
    | RETURN => "RETURN"
    | SUPER => "SUPER"
    | THIS => "THIS"
    | TRUE => "TRUE"
    | VAR => "VAR"
    | WHILE => "WHILE"
    | EOF => "EOF"

end
