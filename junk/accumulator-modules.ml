module type STATEMACHINE = sig
  type t
  type state
  type input
  type output

  val get_start_state : machine:t -> state
  val get_next_state : machine:t -> state:state -> input:input -> state * output
end

module Accumulator : STATEMACHINE = struct
  type t = { initial_value : int }
  type input = int
  type output = int
  type state = int

  let make ~initial_value = { initial_value }
  let get_start_state ~machine = machine.initial_value
  let get_next_state ~machine:_ ~state ~input = (state + input, state + input)
end

(*
module StateMachine (SM: STATEMACHINE) = struct
  type inputs = SM.input list [@@deriving.show]
  
  let trace ~machine:SM.t ~inputs:inputs=
    ()
end
*)

let step ~stepper:{mut state:int} ~input:int =
  

let trace ~machine ~inputs =
  let stepper = { mut state = Accumulator.get_start_state machine} in
  inputs |> List.map (fun i -> step stepper i)

let () =
  let accumulator = Accumulator.make ~initial_value:0 in
  let output = trace accumulator [ (100, -3, 4, -12, 10) ] in
  ()

let () = print_endline "Output: "
