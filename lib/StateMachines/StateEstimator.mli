open Distributions
open StateMachine
open StochasticModel

(** A state estimation state machine. *)
module Make (M : StochasticModel) : sig
  module Input : sig
    type t = M.Input.t * M.Output.t
  end

  module Output : sig
    type t = M.State.t Discrete.t
  end

  include
    StateMachine
    with module Input := Input
     and module Output := Output
     and module State = Output
end
