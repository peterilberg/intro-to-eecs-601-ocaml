open Utilities.Miscellaneous

let of_distributions a b ~mix =
  enforce (0.0 <= mix && mix <= 1.0) "Mix must be between 0.0 and 1.0.";
  let mix_probability event =
    let p_a = Discrete.probability a event in
    let p_b = Discrete.probability b event in
    event, (mix *. p_a) +. ((1.0 -. mix) *. p_b)
  in
  List.append (Discrete.support a) (Discrete.support b)
  |> List.sort_uniq Int.compare
  |> List.map mix_probability
  |> Discrete.of_list
;;
