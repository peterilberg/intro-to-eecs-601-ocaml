open Executable
open StateMachine
open Utilities.Printable

module Make
    (SM : StateMachine)
    (Input : Printable with type t = SM.Input.t)
    (Output : Printable with type t = SM.Output.t)
    (State : Printable with type t = SM.State.t) =
struct
  module E :
    Executable
    with module Input = SM.Input
     and module Output = SM.Output
     and module State = SM.State = struct
    module Input = Input
    module Output = Output
    module State = State

    let start () =
      let state = SM.get_start_state () in
      Printf.printf "Start state: %s\n" (State.to_string state);
      state
    ;;

    let step n state input =
      let state, output = SM.get_next_state state input in
      Printf.printf
        "%d: input %s produces %s with new state: %s\n"
        n
        (Input.to_string input)
        (Output.to_string output)
        (State.to_string state);
      state, output
    ;;

    let finish outputs =
      let elements = List.map Output.to_string outputs in
      let list = "[" ^ String.concat ", " elements ^ "]" in
      Printf.printf "Output: %s\n" list;
      outputs
    ;;
  end

  let run inputs =
    let module Execution = Execution.Make (E) in
    Execution.execute inputs
  ;;
end
