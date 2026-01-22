module type Event = sig
  include Hashtbl.HashedType
end

module Make (E : Event) = struct
  module Table = Hashtbl.Make (E)

  type t = float Table.t
  type u = (E.t * float) Array.t

  let enforce condition message =
    if not condition then Stdlib.invalid_arg message
  ;;

  let normalize events =
    let sum = events |> List.map Pair.snd |> List.fold_left ( +. ) 0.0 in
    enforce
      (sum > 0.0)
      "Sum of weights of discrete events must be greater than 0.";
    events |> List.map (fun (event, weight) -> event, weight /. sum)
  ;;

  let create ~events =
    enforce
      (List.length events <> 0)
      "Discrete distribution must have at least one event.";
    normalize events |> List.to_seq |> Table.of_seq
  ;;

  let support ~distribution = Table.to_seq_keys distribution |> List.of_seq

  let probability ~distribution ~event =
    let option = Table.find_opt distribution event in
    Option.value option ~default:0.0
  ;;

  let draw ~distribution =
    let number = Random.float 1.0 in
    let support = support ~distribution in
    let rec loop sum last = function
      | [] -> last
      | event :: rest ->
        let sum = sum +. probability ~distribution ~event in
        if number <= sum then event else loop sum event rest
    in
    loop 0.0 (List.hd support) (List.tl support)
  ;;
end

(*
    pub fn marginalize<NewEvent, Conversion>(
        &self,
        convert: Conversion,
    ) -> Discrete<NewEvent>
    where
        NewEvent: Clone + Eq + Hash,
        Conversion: Fn(&Event) -> NewEvent,
    {
        let mut distribution = HashMap::new();
        for (old_event, probability) in self.distribution.iter() {
            let new_event = convert(old_event);
            let entry = distribution.entry(new_event).or_insert(0.0);
            *entry += probability;
        }
        Discrete::build(distribution)
    }

    pub fn condition<Filter>(&self, filter: Filter) -> Discrete<Event>
    where
        Filter: FnMut(&&Event) -> bool,
    {
        Discrete::from_iter(
            self.support()
                .filter(filter)
                .map(|event| (event.clone(), self.probability(event))),
        )
    }
}
*)
