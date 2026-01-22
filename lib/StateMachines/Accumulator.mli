open StateMachine.Interfaces
open Utilities.Interfaces

module Make (A : Addable) : sig
  include
    Machine
    with type t = A.t
     and type input = A.t
     and type output = A.t
     and type state = A.t

  val create : initial_value:input -> t
end
