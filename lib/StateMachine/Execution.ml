open Interfaces
open Utilities.Interfaces

module type Executable = sig
  module Input : sig
    type t
  end

  module Output : sig
    type t
  end

  module State : sig
    type t
  end

  val start : unit -> State.t
  val step : int -> State.t -> Input.t -> State.t * Output.t
  val finish : Output.t list -> Output.t list
end

module Execution (E : Executable) = struct
  type 'a t =
    { n : int
    ; state : E.State.t
    ; outputs : E.Output.t list
    }

  let execute inputs =
    let start = { n = 0; state = E.start (); outputs = [] } in
    let step execution input =
      let { state; n; outputs } = execution in
      let state, output = E.step n state input in
      { state; n = n + 1; outputs = output :: outputs }
    in
    let outputs execution = execution.outputs in
    inputs |> List.fold_left step start |> outputs |> List.rev |> E.finish
  ;;
end

module Run (SM : StateMachine) = struct
  module E :
    Executable
    with module Input = SM.Input
     and module Output = SM.Output
     and module State = SM.State = struct
    module Input = SM.Input
    module Output = SM.Output
    module State = SM.State

    let start () = SM.get_start_state ()
    let step _n state input = SM.get_next_state state input
    let finish outputs = outputs
  end

  let run inputs =
    let module Execution = Execution (E) in
    Execution.execute inputs
  ;;
end

module Transitions (SM : StateMachine) = struct
  type transition =
    { n : int
    ; old_state : SM.State.t
    ; new_state : SM.State.t
    ; input : SM.Input.t
    ; output : SM.Output.t
    }

  module Transition = struct
    type t = transition
  end

  module E :
    Executable
    with module Input = SM.Input
     and module Output = Transition
     and module State = SM.State = struct
    module Input = SM.Input
    module Output = Transition
    module State = SM.State

    let start () = SM.get_start_state ()

    let step n old_state input =
      let new_state, output = SM.get_next_state old_state input in
      new_state, { n; old_state; new_state; input; output }
    ;;

    let finish outputs = outputs
  end

  let run inputs =
    let module Execution = Execution (E) in
    Execution.execute inputs
  ;;
end

module Trace
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
    let module Execution = Execution (E) in
    Execution.execute inputs
  ;;
end
