type 'a t =
  { events : 'a array
  ; probabilities : floatarray
  ; cumulative : floatarray
  }

let enforce condition message =
  if not condition then Stdlib.invalid_arg message
;;

let normalize_inplace array =
  let total = Float.Array.fold_left ( +. ) 0.0 array in
  enforce
    (total > 0.0)
    "Sum of weights of discrete events must be greater than 0.";
  Float.Array.map_inplace (fun x -> x /. total) array
;;

let cumulative source =
  let running_total = ref 0.0 in
  Float.Array.init (Float.Array.length source) (fun i ->
    running_total := !running_total +. Float.Array.get source i;
    !running_total)
;;

let of_list events =
  enforce
    (List.length events <> 0)
    "Discrete distribution must have at least one event.";
  let labels, weights = List.split events in
  let events = Array.of_list labels in
  let probabilities = Float.Array.of_list weights in
  normalize_inplace probabilities;
  let cumulative = cumulative probabilities in
  { events; probabilities; cumulative }
;;

let support ~distribution = Array.to_list distribution.events

let probability ~distribution ~event =
  Array.find_index (fun item -> item = event) distribution.events
  |> Option.fold ~none:0.0 ~some:(fun i ->
    Float.Array.get distribution.probabilities i)
;;

let to_list distribution =
  List.combine
    (Array.to_list distribution.events)
    (Float.Array.to_list distribution.probabilities)
;;

let draw ~distribution =
  let number = Random.float 1.0 in
  let test item = number < item in
  Float.Array.find_index test distribution.cumulative
  |> Option.fold ~none:(Array.length distribution.events - 1) ~some:Fun.id
  |> Array.get distribution.events
;;

let marginalize ~distribution ~convert =
  let convert (event, probability) =
    convert event |> Option.map (fun converted -> converted, probability)
  in
  distribution |> to_list |> List.filter_map convert |> of_list
;;

let sample ~distribution ~n = Array.init n (fun _ -> draw ~distribution)

let tally (type a) ~compare samples =
  let module Table =
    Map.Make (struct
      type t = a

      let compare = compare
    end)
  in
  let inc event = event |> Option.fold ~none:1 ~some:Int.succ |> Option.some in
  let collect table event = Table.update event inc table in
  samples |> Array.fold_left collect Table.empty |> Table.to_list
;;
