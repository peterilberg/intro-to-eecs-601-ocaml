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
