(** Create a triangular probability distribution with [peak] and
    [half_width] wings. *)
val of_triangle : peak:int -> half_width:int -> int Discrete.t
