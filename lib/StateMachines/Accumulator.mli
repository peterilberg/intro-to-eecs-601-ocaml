open StateMachine.Interfaces
open Utilities.Interfaces

module Make (A : Addable) : sig
  include
    Machine
    with type t = A.t
     and module Input = A
     and module Output = A
     and module State = A

  val create : initial_value:Input.t -> t
end
