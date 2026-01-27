open Executable
open StateMachine

module Make (SM : StateMachine) = struct
  module E :
    Executable
    with module Input = SM.Input
     and module Output = SM.Output
     and module State = SM.State = struct
    module Input = SM.Input
    module Output = SM.Output
    module State = SM.State

    let start () = SM.get_start_state ()
    let step _n state input = SM.get_next_state state input
    let finish outputs = outputs
  end

  let run inputs =
    let module Execution = Execution.Make (E) in
    Execution.execute inputs
  ;;
end
