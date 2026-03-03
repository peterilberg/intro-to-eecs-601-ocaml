(** Create a mixed probability distribution from two distributions.
    [mix] specifies the relative weight: [mix] * a + (1-[mix]) * b *)

val of_distributions
  :  int Discrete.t
  -> int Discrete.t
  -> mix:float
  -> int Discrete.t
