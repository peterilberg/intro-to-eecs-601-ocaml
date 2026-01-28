open Distributions

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

  val initial_state : State.t Discrete.t
  val transition : Input.t -> (State.t, State.t) Conditional.t
  val observation : (Output.t, State.t) Conditional.t
end
