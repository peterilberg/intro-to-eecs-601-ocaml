type ('a, 'b) t = 'b -> 'a Discrete.t

val join : ('a, 'b) t -> given:'b Discrete.t -> ('a * 'b) Discrete.t

val bayesian_evidence
  :  ('a, 'b) t
  -> prior:'b Discrete.t
  -> evidence:'a
  -> 'b Discrete.t

val total_probability : ('a, 'b) t -> prior:'b Discrete.t -> 'a Discrete.t
