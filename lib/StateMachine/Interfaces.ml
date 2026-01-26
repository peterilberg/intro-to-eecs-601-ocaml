module type Machine = sig
  type t

  module Input : sig
    type t
  end

  module Output : sig
    type t
  end

  module State : sig
    type t
  end

  val get_start_state : machine:t -> State.t

  val get_next_state
    :  machine:t
    -> state:State.t
    -> input:Input.t
    -> State.t * Output.t
end
