open Interfaces

module Make (M : Machine) = struct
  type t =
    { machine : M.t
    ; mutable current_state : M.state
    ; trace_start : M.state -> unit
    ; trace_step : int -> M.state -> M.input -> M.output -> M.state -> unit
    ; trace_result : M.output list -> unit
    }

  let step execution i input =
    let old_state = execution.current_state in
    let new_state, output =
      M.get_next_state ~machine:execution.machine ~state:old_state ~input
    in
    execution.current_state <- new_state;
    execution.trace_step i old_state input output new_state;
    output
  ;;

  let execute execution inputs =
    execution.trace_start execution.current_state;
    let output = inputs |> List.mapi (step execution) in
    execution.trace_result output;
    output
  ;;

  let create ~machine =
    { machine
    ; current_state = M.get_start_state ~machine
    ; trace_start = (fun _ -> ())
    ; trace_step = (fun _ _ _ _ _ -> ())
    ; trace_result = (fun _ -> ())
    }
  ;;

  let run ~execution ~inputs = execute execution inputs

  let trace ~trace_start ~trace_step ~trace_result ~execution =
    { execution with trace_start; trace_step; trace_result }
  ;;

  type transition =
    { step : int
    ; from_state : M.state
    ; to_state : M.state
    ; input : M.input
    ; output : M.output
    }

  let trajectory ~execution ~inputs =
    let transitions = ref [] in
    let trace_step step from_state input output to_state =
      execution.trace_step step from_state input output to_state;
      transitions
      := { step; from_state; input; output; to_state } :: !transitions
    in
    let execution = { execution with trace_step } in
    ignore @@ run ~execution ~inputs;
    List.rev !transitions
  ;;
end
