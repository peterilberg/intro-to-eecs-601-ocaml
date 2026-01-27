let of_list list =
  let n = list |> List.length |> float_of_int in
  let p = 1.0 /. n in
  list |> List.map (fun e -> e, p) |> Discrete.of_list
;;
