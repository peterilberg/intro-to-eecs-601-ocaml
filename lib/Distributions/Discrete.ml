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
  |> List.filter (fun (e, _) -> e = event)
  |> List.map snd
  |> List.fold_left ( +. ) 0.0
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

let sample distribution n = Array.init n (fun _ -> draw distribution)

let tally (type a) ~compare samples =
  let module Table =
    Map.Make (struct
      type t = a

      let compare = compare
    end)
  in
  let inc option =
    option |> Option.fold ~none:1 ~some:Int.succ |> Option.some
  in
  let collect table event = Table.update event inc table in
  samples |> Array.fold_left collect Table.empty |> Table.to_list
;;
