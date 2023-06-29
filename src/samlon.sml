fun run source =
  let val tokens = Scanner.tokens source
  in List.app (fn token => print (Token.toString token ^ "\n")) tokens
  end

fun runScript script =
  let
    val file = TextIO.openIn script
    val source = TextIO.inputAll file
    val _ = TextIO.closeIn file
  in
    run source
  end

fun runPrompt () =
  let
    val _ = print "> "
    val line = TextIO.inputLine TextIO.stdIn
  in
    case line of
      NONE => ()
    | SOME line => (run line; runPrompt ())
  end

fun parseCommandline () =
  case CommandLine.arguments () of
    [] => NONE
  | [script] => SOME script
  | _ => (print "Usage: samlon [script]\n"; OS.Process.exit OS.Process.failure)

fun main () =
  let
    val script = parseCommandline ()
  in
    case script of
      NONE => runPrompt ()
    | SOME script => runScript script
  end
