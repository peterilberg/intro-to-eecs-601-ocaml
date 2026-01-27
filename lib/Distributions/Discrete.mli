type 'a t

val of_list : ('a * float) list -> 'a t
val to_list : 'a t -> ('a * float) list
val support : 'a t -> 'a list
val probability : 'a t -> 'a -> float
val draw : 'a t -> 'a
val marginalize : 'a t -> convert:('a -> 'b option) -> 'b t
val condense : 'a t -> compare:('a -> 'a -> int) -> 'a t
val sample : 'a t -> int -> 'a array
val tally : compare:('a -> 'a -> int) -> 'a array -> ('a * int) list
