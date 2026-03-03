open Distributions

(** A stochastic model for a state machine. *)
module type StochasticModel = sig
  module Input : sig
    type t
  end

  module Output : sig
    type t
  end

  module State : sig
    type t
  end

  (** The probability distribution for the initial state. *)
  val initial_state : State.t Discrete.t

  (** The conditional distribution for the state transition. *)
  val transition : Input.t -> (State.t, State.t) Conditional.t

  (** The conditional distribution for the output. *)
  val observation : (Output.t, State.t) Conditional.t
end
