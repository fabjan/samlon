structure Scanner =
struct

  open Token

  fun identifier "and" = AND
    | identifier "class" = CLASS
    | identifier "else" = ELSE
    | identifier "false" = FALSE
    | identifier "for" = FOR
    | identifier "fun" = FUN
    | identifier "if" = IF
    | identifier "nil" = NIL
    | identifier "or" = OR
    | identifier "print" = PRINT
    | identifier "return" = RETURN
    | identifier "super" = SUPER
    | identifier "this" = THIS
    | identifier "true" = TRUE
    | identifier "var" = VAR
    | identifier "while" = WHILE
    | identifier id = IDENTIFIER id

  fun lookahead source pos =
    let
      fun sub off =
        Substring.sub (source, pos + off)
    in
      case (Substring.size source) - pos of
        0 => NONE
      | 1 => SOME (sub 0, NONE)
      | _ => SOME (sub 0, SOME (sub 1))
    end

  fun countLines ss =
    Substring.foldl (fn (#"\n", n) => n + 1 | (_, n) => n) 0 ss

  fun skipWhitespace source pos line =
    let
      val rest = Substring.slice (source, pos, NONE)
      val whitespace = Substring.takel Char.isSpace rest
      val newlines = countLines whitespace
    in
      (pos + Substring.size whitespace, line + newlines)
    end

  fun skipComment source pos line =
    let
      val rest = Substring.slice (source, pos, NONE)
      val comment = Substring.takel (fn c => c <> #"\n") rest
      val skip = Substring.size comment + 1 (* +1 for the newline *)
    in
      (pos + skip, line + 1)
    end

  fun scanNumber source pos =
    let
      val rest = Substring.slice (source, pos, NONE)
      val digits = Substring.takel Char.isDigit rest
      val skip = Substring.size digits
    in
      (pos + skip, valOf (Real.fromString (Substring.string digits)))
    end

  fun scanIdentifier source pos =
    let
      val rest = Substring.slice (source, pos, NONE)
      val id = Substring.takel Char.isAlphaNum rest
      val skip = Substring.size id
    in
      (pos + skip, Substring.string id)
    end

  fun scanStringLiteral source pos line =
    let
      val rest = Substring.slice (source, pos + 1, NONE)
      val str = Substring.takel (fn c => c <> #"\"") rest
      val skip = Substring.size str + 2 (* +2 for the quotes *)
    in
      if Substring.size str = Substring.size rest then
        Errors.error line "Unterminated string"
      else
        ();
      (pos + skip, line + countLines str, Substring.string str)
    end

  fun scan source pos line acc =
    let
      fun continue skip tok =
        scan source (pos + skip) line (tok :: acc)
      fun skip p l =
        scan source (pos + p) (line + l) acc
    in
      case lookahead source pos of
        NONE => List.rev (EOF :: acc)
      | SOME (#"!", SOME #"=") => continue 2 BANG_EQUAL
      | SOME (#"=", SOME #"=") => continue 2 EQUAL_EQUAL
      | SOME (#"<", SOME #"=") => continue 2 LESS_EQUAL
      | SOME (#">", SOME #"=") => continue 2 GREATER_EQUAL
      | SOME (#"/", SOME #"/") =>
          let val (pos, line) = skipComment source pos line
          in scan source pos line acc
          end
      | SOME (#"/", _) => continue 1 SLASH
      | SOME (#"!", _) => continue 1 BANG
      | SOME (#"=", _) => continue 1 EQUAL
      | SOME (#"<", _) => continue 1 LESS
      | SOME (#">", _) => continue 1 GREATER
      | SOME (#"(", _) => continue 1 LEFT_PAREN
      | SOME (#")", _) => continue 1 RIGHT_PAREN
      | SOME (#"{", _) => continue 1 LEFT_BRACE
      | SOME (#"}", _) => continue 1 RIGHT_BRACE
      | SOME (#",", _) => continue 1 COMMA
      | SOME (#".", _) => continue 1 DOT
      | SOME (#"-", _) => continue 1 MINUS
      | SOME (#"+", _) => continue 1 PLUS
      | SOME (#";", _) => continue 1 SEMICOLON
      | SOME (#"*", _) => continue 1 STAR
      | SOME (#" ", _) => skip 1 0
      | SOME (#"\r", _) => skip 1 0
      | SOME (#"\t", _) => skip 1 0
      | SOME (#"\n", _) => skip 1 1
      | SOME (#"\"", _) =>
          let val (pos, line, str) = scanStringLiteral source pos line
          in scan source pos line (STRING str :: acc)
          end
      | SOME (c, _) =>
          if Char.isDigit c then
            let val (pos, num) = scanNumber source pos
            in scan source pos line (NUMBER num :: acc)
            end
          else if Char.isAlpha c then
            let val (pos, id) = scanIdentifier source pos
            in scan source pos line (identifier id :: acc)
            end
          else
            ( Errors.error line ("Unexpected character: " ^ (Char.toString c))
            ; scan source (pos + 1) line acc
            )
    end

  fun tokens source =
    scan (Substring.full source) 0 1 []

end
