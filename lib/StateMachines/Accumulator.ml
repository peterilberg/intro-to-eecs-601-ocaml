open StateMachine.Interfaces
open Utilities.Interfaces

module Make
    (A : Addable)
    (C : sig
       val initial_value : A.t
     end) =
struct
  module Input = A
  module Output = A
  module State = A

  let get_start_state () = C.initial_value

  let get_next_state ~state ~input =
    let sum = A.add state input in
    sum, sum
  ;;
end

module _ : StateMachine =
  Make
    (Int)
    (struct
      let initial_value = 0
    end)
