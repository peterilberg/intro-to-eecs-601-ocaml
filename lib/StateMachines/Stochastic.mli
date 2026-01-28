open StateMachine
open StochasticModel

module Make (M : StochasticModel) : sig
  include
    StateMachine
    with module Input = M.Input
     and module Output = M.Output
     and module State = M.State
end
