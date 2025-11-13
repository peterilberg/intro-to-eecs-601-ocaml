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
