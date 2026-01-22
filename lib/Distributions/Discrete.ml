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

let remove_duplicates (type a) compare' list =
  let module E = struct
    type t = a

    let compare = compare'
  end
  in
  let module Map = Map.Make (E) in
  list
  |> List.fold_left
       (fun map (e, p) ->
          Map.update
            e
            (function
              | None -> Some p
              | Some p' -> Some (p +. p'))
            map)
       Map.empty
  |> Map.to_list
;;

let create ~events ~compare =
  enforce
    (List.length events <> 0)
    "Discrete distribution must have at least one event.";
  let events = remove_duplicates compare events in
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

let draw ~distribution =
  let number = Random.float 1.0 in
  let test item = number < item in
  Float.Array.find_index test distribution.cumulative
  |> Option.fold ~none:(Array.length distribution.events - 1) ~some:Fun.id
  |> Array.get distribution.events
;;

let to_list distribution =
  support ~distribution
  |> List.map (fun event -> event, probability ~distribution ~event)
;;

let of_list events =
  (* TODO create ~events ~compare:??? *)
  { events = Array.of_list (events |> List.map fst)
  ; probabilities = Float.Array.create 1
  ; cumulative = Float.Array.create 1
  }
;;

let marginalize ~distribution ~convert =
  let events = Array.to_seq distribution.events in
  let probabilities = Float.Array.to_seq distribution.probabilities in
  create
    ~events:
      (Seq.zip events probabilities
       |> Seq.filter_map (fun (e, p) -> Option.map (fun e -> e, p) (convert e))
       |> List.of_seq)
;;
