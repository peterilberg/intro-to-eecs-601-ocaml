open StateMachine

module Make (SM : StateMachine) : sig
  type transition =
    { n : int
    ; old_state : SM.State.t
    ; new_state : SM.State.t
    ; input : SM.Input.t
    ; output : SM.Output.t
    }

  val run : SM.Input.t list -> transition list
end
