type ('a, 'b) t = 'b -> 'a Discrete.t

let join conditional ~given =
  given
  |> Discrete.to_list
  |> List.map (fun (given, condition) ->
    conditional given
    |> Discrete.to_list
    |> List.map (fun (event, probability) ->
      (event, given), probability *. condition))
  |> List.flatten
  |> Discrete.of_list
;;

let bayesian_evidence conditional ~prior ~evidence =
  let convert (event, given) =
    if event = evidence then Option.some given else Option.none
  in
  join conditional ~given:prior |> Discrete.marginalize ~convert
;;

let total_probability conditional ~prior =
  let convert (event, _given) = Option.some event in
  join conditional ~given:prior |> Discrete.marginalize ~convert
;;
