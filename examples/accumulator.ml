open IntroToEeAndCsWithOcaml
module Accumulator = StateMachines.Accumulator

module Types = struct
  type input = int [@@deriving show]
  type output = int [@@deriving show]
  type state = int [@@deriving show]
  type output_list = output list [@@deriving show]
end

module AccumulatorInt = Accumulator.Make (
    struct
      type t = Types.state

      let accumulate = Int.add
    end :
      Accumulator.Accumulable with type t = int)

let trace =
  let trace_start state =
    Printf.printf "Start state: %s\n" (Types.show_state state)
  in
  let trace_step i input output state =
    Printf.printf
      "%d: input %s produces %s with new state: %s\n"
      i
      (Types.show_input input)
      (Types.show_output output)
      (Types.show_state state)
  in
  StateMachine.trace ~trace_start ~trace_step
;;

let () =
  let accumulator = AccumulatorInt.make_with ~initial_value:0 in
  let inputs = [ 100; -3; 4; -123; 10 ] in
  let outputs = trace ~machine:accumulator ~inputs in
  Printf.printf "Output: %s" (Types.show_output_list outputs)
;;
