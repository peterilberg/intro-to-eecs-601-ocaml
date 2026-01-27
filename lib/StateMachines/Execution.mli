open Executable

module Make (E : Executable) : sig
  val execute : E.Input.t list -> E.Output.t list
end
