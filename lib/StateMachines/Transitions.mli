open StateMachine

(** Transitions from an execution of a state machine. *)
module Make (SM : StateMachine) : sig
  type transition =
    { n : int (** The execution step. *)
    ; old_state : SM.State.t
    ; new_state : SM.State.t
    ; input : SM.Input.t
    ; output : SM.Output.t
    }

  (** Collect the transitions that a state machine goes through when you
      run it on some input. *)
  val run : SM.Input.t list -> transition list
end
