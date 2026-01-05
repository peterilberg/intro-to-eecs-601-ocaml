module type STATEMACHINE = sig
  type state
  type input
  type output

  val get_start_state : unit -> state
  val get_next_state : state:state -> input:input -> state * output
end

module type TraceableStateMachine = sig
  include STATEMACHINE

  val show_state : state -> string
  val show_input : input -> string
  val show_output : output -> string
end

module type Addable = sig
  type t

  val add : t -> t -> t
end

module type Showable = sig
  type t

  val show : t -> string
end

(* TODO split this into two separate functors *)
(* doesn't work because MakeAccumulator is not a STATEMACHINE *)
(* it returns a first-class module instead of that type *)
(* so we cannot pass it into a functor *)
(* and we must build it this way to customize the initial value *)
module MakeAccumulator
    (Adder : Addable)
    (Shower : Showable with type t = Adder.t) =
struct
  let with_initial_value initial_value =
    (module struct
      type state = Adder.t
      type input = Adder.t
      type output = Adder.t

      let get_start_state () = initial_value

      let get_next_state ~state ~input =
        let sum = Adder.add state input in
        (sum, sum)

      let show_state = Shower.show
      let show_input = Shower.show
      let show_output = Shower.show
    end : TraceableStateMachine
      with type state = Adder.t
       and type input = Adder.t
       and type output = Adder.t)
end

module IntAddable : Addable with type t = int = struct
  type t = int

  let add = Int.add
end

module IntShowable : Showable with type t = int = struct
  type t = int

  let show = Int.to_string
end

module IntAccumulator = MakeAccumulator (IntAddable) (IntShowable)

module type Stepper = sig
  type state
  type input
  type output

  val state : unit -> state
  val step : input:input -> output
end

let stepper (type s) (type i) (type o)
    (module SM : STATEMACHINE
      with type state = s
       and type input = i
       and type output = o) =
  (module struct
    type state = s
    type input = i
    type output = o
    type stepper_state = { mutable state : s }

    let internal = { state = SM.get_start_state () }
    let state () = internal.state

    let step ~input =
      let s, o = SM.get_next_state ~state:(state ()) ~input in
      internal.state <- s;
      o
  end : Stepper
    with type state = s
     and type input = i
     and type output = o)

let trace (type s) (type i) (type o)
    (module SM : TraceableStateMachine
      with type state = s
       and type input = i
       and type output = o) inputs =
  let stepper = stepper (module SM) in
  let (module STEP : Stepper
        with type state = s
         and type input = i
         and type output = o) =
    stepper
  in
  Printf.printf "Start state: %s\n" (SM.show_state (STEP.state ()));
  inputs
  |> List.mapi (fun i input ->
      let o = STEP.step ~input in
      Printf.printf "%d: input %s produces %s with new state: %s\n" i
        (SM.show_input input) (SM.show_output o)
        (SM.show_state (STEP.state ()));
      o)

type outputs = int list [@@deriving show]

let () =
  let accumulator = IntAccumulator.with_initial_value 0 in
  let inputs = [ 100; -3; 4; -123; 10 ] in
  let outputs = trace accumulator inputs in
  Format.printf "Output: %s" (show_outputs outputs)
