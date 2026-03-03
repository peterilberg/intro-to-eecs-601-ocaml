(** [Printable] defines the interface for printable types *)
module type Printable = sig
  (** The printable type *)
  type t

  (** Printable types must provide [to_string] function. *)
  val to_string : t -> string
end
