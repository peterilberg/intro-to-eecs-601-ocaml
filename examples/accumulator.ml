module StateMachine : sig
  type ('input, 'output, 'state) t

  val make_with
    :  get_start_state:(unit -> 'state)
    -> get_next_state:('state -> 'input -> 'state * 'output)
    -> ('input, 'output, 'state) t

  val trace
    :  trace_start:('state -> unit)
    -> trace_step:(int -> 'input -> 'output -> 'state -> unit)
    -> machine:('input, 'output, 'state) t
    -> inputs:'input list
    -> 'output list
end = struct
  type ('input, 'output, 'state) t =
    { get_start_state : unit -> 'state
    ; get_next_state : 'state -> 'input -> 'state * 'output
    }

  let make_with ~get_start_state ~get_next_state = { get_start_state; get_next_state }

  let trace ~trace_start ~trace_step ~machine ~inputs =
    let state = ref (machine.get_start_state ()) in
    let step i =
      let s', o = machine.get_next_state !state i in
      state := s';
      o
    in
    trace_start !state;
    inputs
    |> List.mapi (fun i input ->
      let o = step input in
      trace_step i input o !state;
      o)
  ;;
end

module type Accumulable = sig
  type t

  val accumulate : t -> t -> t
end

module AccumulatorMake (A : Accumulable) = struct
  let make_with ~initial_value =
    let get_start_state () = initial_value in
    let get_next_state s i =
      let sum = A.accumulate s i in
      sum, sum
    in
    StateMachine.make_with ~get_start_state ~get_next_state
  ;;
end

module AccumulableInt : Accumulable with type t = int = struct
  type t = int

  let accumulate = Int.add
end

module AccumulatorInt = AccumulatorMake (AccumulableInt)

type input = int [@@deriving show]
type output = int [@@deriving show]
type state = int [@@deriving show]
type outputs = int list [@@deriving show]

let trace =
  let trace_start state = Printf.printf "Start state: %s\n" (show_state state) in
  let trace_step i input output state =
    Printf.printf
      "%d: input %s produces %s with new state: %s\n"
      i
      (show_input input)
      (show_output output)
      (show_state state)
  in
  StateMachine.trace ~trace_start ~trace_step
;;

let () =
  let accumulator = AccumulatorInt.make_with ~initial_value:0 in
  let inputs = [ 100; -3; 4; -123; 10 ] in
  let outputs = trace ~machine:accumulator ~inputs in
  Printf.printf "Output: %s" (show_outputs outputs)
;;
