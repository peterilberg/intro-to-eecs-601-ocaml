module type Addable = sig
  type t

  val add : t -> t -> t
end

module type Printable = sig
  type t

  val to_string : t -> string
end
