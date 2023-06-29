structure Errors =
struct

  val hadError = ref false

  fun report line what message =
    let
      val output =
        "[line " ^ Int.toString line ^ "] Error" ^ what ^ ": " ^ message ^ "\n"
    in
      hadError := true;
      print output
    end

  fun error line message =
    report line "" message

end
