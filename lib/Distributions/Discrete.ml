open Utilities.Miscellaneous

type 'a t = ('a * float) list

let normalize list =
  let sum = list |> List.map snd |> List.fold_left ( +. ) 0.0 in
  enforce
    (sum > 0.0)
    "Sum of weights of discrete events must be greater than 0.";
  let normalize (e, p) = e, p /. sum in
  List.map normalize list
;;

let of_list events =
  enforce
    (List.length events <> 0)
    "Discrete distribution must have at least one event.";
  normalize events
;;

let to_list distribution = distribution
let support distribution = List.map fst distribution

let probability distribution event =
  distribution
  |> List.find_opt (fun (e, _) -> e = event)
  |> Option.fold ~none:0.0 ~some:snd
;;

let draw distribution =
  let number = Random.float 1.0 in
  let rec find sum = function
    | [] -> failwith "Discrete distribution cannot be empty."
    | [ (e, _) ] -> e
    | (e, p) :: _ when number < sum +. p -> e
    | (_, p) :: rest -> find (sum +. p) rest
  in
  find 0.0 distribution
;;

let marginalize distribution ~convert =
  let convert (e, p) = convert e |> Option.map (fun e -> e, p) in
  distribution |> to_list |> List.filter_map convert |> of_list
;;

let collect (type a) ~compare ~key ~default ~update sequence =
  let module Table =
    Map.Make (struct
      type t = a

      let compare = compare
    end)
  in
  let update item found =
    found
    |> Option.fold ~none:(default item) ~some:(fun value -> update item value)
    |> Option.some
  in
  let process table item = Table.update (key item) (update item) table in
  sequence |> Seq.fold_left process Table.empty |> Table.to_list
;;

let condense distribution ~compare =
  distribution
  |> to_list
  |> List.to_seq
  |> collect ~compare ~key:fst ~default:snd ~update:(fun (_, p) v -> p +. v)
;;

let sample distribution n = Array.init n (fun _ -> draw distribution)

let tally ~compare samples =
  samples
  |> Array.to_seq
  |> collect ~compare ~key:Fun.id ~default:(Fun.const 1) ~update:(fun _ ->
    Int.succ)
;;
