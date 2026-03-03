open StateMachine
open Utilities.Printable

(** An execution trace of a state machine. *)
module Make
    (SM : StateMachine)
    (_ : Printable with type t = SM.Input.t)
    (_ : Printable with type t = SM.Output.t)
    (_ : Printable with type t = SM.State.t) : sig
  (** Run a state machine and print an execution trace. *)
  val run : SM.Input.t list -> SM.Output.t list
end
