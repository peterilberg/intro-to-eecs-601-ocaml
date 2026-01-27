open StateMachine.Interfaces
open Utilities.Interfaces

module Make
    (A : Addable)
    (_ : sig
       val initial_value : A.t
     end) : sig
  include
    StateMachine
    with module Input = A
     and module Output = A
     and module State = A
end
