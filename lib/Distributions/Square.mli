(** Create a square probability distribution with [low] and
    [high] limits. *)
val of_interval : low:int -> high:int -> int Discrete.t
