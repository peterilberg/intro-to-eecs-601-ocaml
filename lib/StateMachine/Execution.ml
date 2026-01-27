open Interfaces
open Utilities.Interfaces

module Make (SM : StateMachine) = struct
  type 'a execution =
    { state : SM.State.t
    ; n : int
    ; result : 'a
    }

  (* TODO extract start, step, result into local module? *)
  let run ~inputs =
    let start = { state = SM.get_start_state (); n = 0; result = [] } in
    let step execution input =
      let { state; n; result } = execution in
      let state, output = SM.get_next_state ~state ~input in
      { state; n = n + 1; result = output :: result }
    in
    let result execution = execution.result |> List.rev in
    inputs |> List.fold_left step start |> result
  ;;

  type transition =
    { step : int
    ; from_state : SM.State.t
    ; to_state : SM.State.t
    ; input : SM.Input.t
    ; output : SM.Output.t
    }

  let transitions ~inputs =
    let start = { state = SM.get_start_state (); n = 0; result = [] } in
    let step execution input =
      let { state = from_state; n; result } = execution in
      let to_state, output = SM.get_next_state ~state:from_state ~input in
      let transition = { step = n; from_state; to_state; input; output } in
      { state = to_state; n = n + 1; result = transition :: result }
    in
    let result execution = execution.result |> List.rev in
    inputs |> List.fold_left step start |> result
  ;;

  module Trace
      (Input : Printable with type t = SM.Input.t)
      (Output : Printable with type t = SM.Output.t)
      (State : Printable with type t = SM.State.t) =
  struct
    let trace_start state =
      Printf.printf "Start state: %s\n" (State.to_string state)
    ;;

    let trace_step n input output state =
      Printf.printf
        "%d: input %s produces %s with new state: %s\n"
        n
        (Input.to_string input)
        (Output.to_string output)
        (State.to_string state)
    ;;

    let trace_result result =
      let elements = List.map Output.to_string result in
      let list = "[" ^ String.concat ", " elements ^ "]" in
      Printf.printf "Output: %s\n" list
    ;;

    let run ~inputs =
      let start =
        let start = { state = SM.get_start_state (); n = 0; result = [] } in
        trace_start start.state;
        start
      in
      let step execution input =
        let { state; n; result } = execution in
        let state, output = SM.get_next_state ~state ~input in
        trace_step n input output state;
        { state; n = n + 1; result = output :: result }
      in
      let result execution =
        let result = execution.result |> List.rev in
        trace_result result;
        result
      in
      inputs |> List.fold_left step start |> result
    ;;
  end
end
