open Interfaces
open Utilities.Interfaces

module Run (SM : StateMachine) : sig
  val run : SM.Input.t list -> SM.Output.t list
end

module Transitions (SM : StateMachine) : sig
  type transition =
    { n : int
    ; old_state : SM.State.t
    ; new_state : SM.State.t
    ; input : SM.Input.t
    ; output : SM.Output.t
    }

  val run : SM.Input.t list -> transition list
end

module Trace
    (SM : StateMachine)
    (_ : Printable with type t = SM.Input.t)
    (_ : Printable with type t = SM.Output.t)
    (_ : Printable with type t = SM.State.t) : sig
  val run : SM.Input.t list -> SM.Output.t list
end
