let of_interval ~low ~high =
  let low' = min low high in
  let high' = max low high in
  Seq.ints low' |> Seq.take (high' - low') |> List.of_seq |> Uniform.of_list
;;
