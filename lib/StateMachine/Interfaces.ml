module type StateMachine = sig
  module Input : sig
    type t
  end

  module Output : sig
    type t
  end

  module State : sig
    type t
  end

  val get_start_state : unit -> State.t
  val get_next_state : state:State.t -> input:Input.t -> State.t * Output.t
end
