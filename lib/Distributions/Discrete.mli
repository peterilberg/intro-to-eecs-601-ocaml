module type Event = sig
  include Hashtbl.HashedType
end

module Make (E : Event) : sig
  type t

  val create : events:(E.t * float) list -> t
  val support : distribution:t -> E.t list
  val probability : distribution:t -> event:E.t -> float
  val draw : distribution:t -> E.t
end
