open StateMachine
open Utilities.Printable

module Make
    (SM : StateMachine)
    (_ : Printable with type t = SM.Input.t)
    (_ : Printable with type t = SM.Output.t)
    (_ : Printable with type t = SM.State.t) : sig
  val run : SM.Input.t list -> SM.Output.t list
end
