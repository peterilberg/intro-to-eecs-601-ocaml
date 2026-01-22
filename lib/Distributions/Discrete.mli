type 'a t

(* TODO remove create, use of_list *)
val create : events:('a * float) list -> compare:('a -> 'a -> int) -> 'a t
val support : distribution:'a t -> 'a list
val probability : distribution:'a t -> event:'a -> float
val draw : distribution:'a t -> 'a
val to_list : 'a t -> ('a * float) list
val of_list : ('a * float) list -> 'a t

(* TODO
   val sample: ~n:int -> distribution:'a t -> 'a array
   val collect : compare:('a -> 'a -> int) -> 'a array -> 'a array * int array
 *)

(* TODO move to utilities? *)
val remove_duplicates
  :  ('a -> 'a -> int)
  -> ('a * float) list
  -> ('a * float) list

(* TODO remove, it's equivalent to to_list |> List.filter_map |> of_list *)
val marginalize
  :  distribution:'a t
  -> convert:('a -> 'b option)
  -> compare:('b -> 'b -> int)
  -> 'b t
