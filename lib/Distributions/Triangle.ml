let of_triangle ~peak ~half_width =
  let wing add i = add peak (i + 1), half_width - i in
  let peak = peak, half_width + 1 in
  let left = Seq.init half_width (wing ( - )) in
  let right = Seq.init half_width (wing ( + )) in
  Seq.cons peak (Seq.append left right)
  |> List.of_seq
  |> List.map (fun (e, p) -> e, float_of_int p)
  |> List.sort (fun (e1, _) (e2, _) -> Int.compare e1 e2)
  |> Discrete.of_list
;;
