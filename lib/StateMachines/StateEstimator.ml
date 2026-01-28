open Distributions
open StochasticModel

module Make (M : StochasticModel) = struct
  module Interaction = struct
    type t = M.Input.t * M.Output.t
  end

  module Estimate = struct
    type t = M.State.t Discrete.t
  end

  module Input = Interaction
  module Output = Estimate
  module State = Estimate

  let get_start_state () = M.initial_state

  let get_next_state state (action, observation) =
    let estimate =
      M.observation
      |> Conditional.bayesian_evidence ~prior:state ~evidence:observation
    in
    let state =
      M.transition action |> Conditional.total_probability ~prior:estimate
    in
    state, estimate
  ;;
end
