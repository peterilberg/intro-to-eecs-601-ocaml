open StateMachine.Interfaces
open Utilities.Interfaces

module Make (A : Addable) = struct
  type t = A.t
  type input = A.t
  type output = A.t
  type state = A.t

  let create ~initial_value = initial_value
  let get_start_state ~machine = machine

  let get_next_state ~machine:_ ~state ~input =
    let sum = A.add state input in
    sum, sum
  ;;
end

module _ : Machine = Make (Int)
