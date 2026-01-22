module type Machine = sig
  type t
  type input
  type output
  type state

  val get_start_state : machine:t -> state

  val get_next_state
    :  machine:t
    -> state:state
    -> input:input
    -> state * output
end
