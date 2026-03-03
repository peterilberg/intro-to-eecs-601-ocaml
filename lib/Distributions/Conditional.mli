(** A conditional distribution P(A | B) is modeled as a function from the
    conditioning event B to a dependent discrete distribution A. *)
type ('a, 'b) t = 'b -> 'a Discrete.t

(** Join a conditional distribution with a discrete distribution:
    P(A x B) = P(A | B) * P(B) *)
val join : ('a, 'b) t -> given:'b Discrete.t -> ('a * 'b) Discrete.t

(** Perform Bayesian inference. Calculate the posterior distribution
    from the joint distribution, the prior, and the observed evidence. *)
val bayesian_evidence
  :  ('a, 'b) t
  -> prior:'b Discrete.t
  -> evidence:'a
  -> 'b Discrete.t

(** Calculate the total probability from the joint distribution and the
    prior. *)
val total_probability : ('a, 'b) t -> prior:'b Discrete.t -> 'a Discrete.t
