open Interfaces
open Utilities.Interfaces

module Make (SM : StateMachine) : sig
  val run : inputs:SM.Input.t list -> SM.Output.t list

  type transition =
    { step : int
    ; from_state : SM.State.t
    ; to_state : SM.State.t
    ; input : SM.Input.t
    ; output : SM.Output.t
    }

  val transitions : inputs:SM.Input.t list -> transition list

  module Trace
      (Input : Printable with type t = SM.Input.t)
      (Output : Printable with type t = SM.Output.t)
      (_ : Printable with type t = SM.State.t) : sig
    val run : inputs:Input.t list -> Output.t list
  end
end
