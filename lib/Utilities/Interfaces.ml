module type Addable = sig
  type t

  val add : t -> t -> t
end
