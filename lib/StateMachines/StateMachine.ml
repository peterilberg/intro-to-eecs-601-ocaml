(** A state machine. *)
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

  (** Get the start state for an execution. *)
  val get_start_state : unit -> State.t

  (** Provide input and get the new state and output. *)
  val get_next_state : State.t -> Input.t -> State.t * Output.t
end
