open StateMachine

module Make (SM : StateMachine) : sig
  val run : SM.Input.t list -> SM.Output.t list
end
