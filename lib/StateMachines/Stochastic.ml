open Distributions
open StochasticModel

module Make (M : StochasticModel) = struct
  module Input = M.Input
  module Output = M.Output
  module State = M.State

  let get_start_state () = Discrete.draw @@ M.initial_state

  let get_next_state state input =
    let output = Discrete.draw @@ M.observation state in
    let state = Discrete.draw @@ M.transition input state in
    state, output
  ;;
end
