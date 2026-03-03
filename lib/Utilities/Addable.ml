(** [Addable] defines the interface for addable types *)
module type Addable = sig
  (** The addable type *)
  type t

  (** Addable types must provide an [add] function. *)
  val add : t -> t -> t
end
