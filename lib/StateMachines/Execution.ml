open Executable

module Make (E : Executable) = struct
  type 'a t =
    { n : int
    ; state : E.State.t
    ; outputs : E.Output.t list
    }

  let execute inputs =
    let start = { n = 0; state = E.start (); outputs = [] } in
    let step execution input =
      let { state; n; outputs } = execution in
      let state, output = E.step n state input in
      { state; n = n + 1; outputs = output :: outputs }
    in
    let outputs execution = execution.outputs in
    inputs |> List.fold_left step start |> outputs |> List.rev |> E.finish
  ;;
end
