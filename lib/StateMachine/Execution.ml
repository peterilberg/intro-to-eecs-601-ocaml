open Interfaces

module Make (M : Machine) = struct
  type t =
    { machine : M.t
    ; mutable current_state : M.state
    ; execute : t -> M.input list -> M.output list
    }

  let execute ~trace_start ~trace_step ~trace_result execution inputs =
    let step i input =
      let old_state = execution.current_state in
      let new_state, output =
        M.get_next_state ~machine:execution.machine ~state:old_state ~input
      in
      execution.current_state <- new_state;
      trace_step i old_state input output new_state;
      output
    in
    trace_start execution.current_state;
    let output = inputs |> List.mapi step in
    trace_result output;
    output
  ;;

  let create ~machine =
    { machine
    ; current_state = M.get_start_state ~machine
    ; execute =
        execute
          ~trace_start:(fun _ -> ())
          ~trace_step:(fun _ _ _ _ _ -> ())
          ~trace_result:(fun _ -> ())
    }
  ;;

  let trace ~trace_start ~trace_step ~trace_result ~execution =
    { execution with execute = execute ~trace_start ~trace_step ~trace_result }
  ;;

  let run ~execution ~inputs = execution.execute execution inputs
end
