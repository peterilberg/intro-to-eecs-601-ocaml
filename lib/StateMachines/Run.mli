open StateMachine

(** Run a state machine on a list of inputs. *)
module Make (SM : StateMachine) : sig
  (** Run a state machine on a list of inputs. *)
  val run : SM.Input.t list -> SM.Output.t list
end
