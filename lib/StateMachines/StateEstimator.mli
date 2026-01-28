open Distributions
open StateMachine
open StochasticModel

module Make (M : StochasticModel) : sig
  module Interaction : sig
    type t = M.Input.t * M.Output.t
  end

  module Estimate : sig
    type t = M.State.t Discrete.t
  end

  include
    StateMachine
    with module Input = Interaction
     and module Output = Estimate
     and module State = Estimate
end
