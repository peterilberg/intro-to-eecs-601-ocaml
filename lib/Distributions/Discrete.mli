type 'a t

val of_list : ('a * float) list -> 'a t
val to_list : 'a t -> ('a * float) list
val support : distribution:'a t -> 'a list
val probability : distribution:'a t -> event:'a -> float
val draw : distribution:'a t -> 'a
val marginalize : distribution:'a t -> convert:('a -> 'b option) -> 'b t
val sample : distribution:'a t -> n:int -> 'a array
val tally : compare:('a -> 'a -> int) -> 'a array -> ('a * int) list
