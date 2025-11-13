module type Accumulable = sig
  type t

  val accumulate : t -> t -> t
end

module Make (A : Accumulable) : sig
  val make_with : initial_value:A.t -> (A.t, A.t, A.t) StateMachine.t
end
