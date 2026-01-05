(*

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
*)

(*
module StateMachine (SM: STATEMACHINE) = struct
  type inputs = SM.input list [@@deriving.show]
  
  let trace ~machine:SM.t ~inputs:inputs=
    ()
end

  Module type SM = sig
	type state
	type input
	type output
	get start state
	get next state
End

Let accumulator (type a) (module A : Addable with type t = a) ~initial:value:a =
	(module struct
		type state = A.t
		type input = int
		type output = int
		let get_start_state = value
		let get_next_state ~state:state ~input:input = (state + input, ...)
	end : SM with type state = int, input = A.t, ...)

Let trace ~machine:(module M : StateMachine) =
	let (state', output) M.get_next_state ~state:state ~input:input in
	...

*)

(*
let step ~stepper:{mut state:int} ~input:int =
  

let trace ~machine ~inputs =
  let stepper = { mut state = Accumulator.get_start_state machine} in
  inputs |> List.map (fun i -> step stepper i)
*)
(*
module type Addable = sig
  type t

  val add : t -> t -> t
end
type t = { initial_value : int }

let make ~initial_value:value = { initial_value = value }
*)

module type STATEMACHINE = sig
  type state
  type input
  type output

  val get_start_state : unit -> state
  val get_next_state : state:state -> input:input -> state * output
end

let make_accumulator ~initial_value =
  (module struct
    type state = int
    type input = int
    type output = int

    let get_start_state () = initial_value
    let get_next_state ~state ~input = (state + input, state + input)
  end : STATEMACHINE
    with type state = int
     and type input = int
     and type output = int)

let get_start_state accumulator = accumulator
let get_next_state _accumulator state input = (state + input, state + input)

type stepper_state = { mutable state : int }

let stepper accumulator =
  let state = get_start_state accumulator in
  { state }

let step accumulator stepper =
 fun input ->
  let s, o = get_next_state accumulator stepper.state input in
  stepper.state <- s;
  o

let trace accumulator inputs =
  let stepper = stepper accumulator in
  Format.printf "Start state: %d\n" stepper.state;
  inputs
  |> List.mapi (fun i input ->
      let o = step accumulator stepper input in
      Format.printf "%d: input %d produces %d with new state: %d\n" i input o
        stepper.state;
      o)

type outputs = int list [@@deriving show]

let () =
  let foo = make_accumulator ~initial_value:0 in
  let accumulator = 0 in
  let inputs = [ 100; -3; 4; -123; 10 ] in
  let outputs = trace accumulator inputs in
  Format.printf "Output: %s" (show_outputs outputs)
