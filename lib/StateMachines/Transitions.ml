open Executable
open StateMachine

module Make (SM : StateMachine) = struct
  type transition =
    { n : int
    ; old_state : SM.State.t
    ; new_state : SM.State.t
    ; input : SM.Input.t
    ; output : SM.Output.t
    }

  module Transition = struct
    type t = transition
  end

  module E :
    Executable
    with module Input = SM.Input
     and module Output = Transition
     and module State = SM.State = struct
    module Input = SM.Input
    module Output = Transition
    module State = SM.State

    let start () = SM.get_start_state ()

    let step n old_state input =
      let new_state, output = SM.get_next_state old_state input in
      new_state, { n; old_state; new_state; input; output }
    ;;

    let finish outputs = outputs
  end

  let run inputs =
    let module Execution = Execution.Make (E) in
    Execution.execute inputs
  ;;
end
