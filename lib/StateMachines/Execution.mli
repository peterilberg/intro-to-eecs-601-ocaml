open Executable

(** Start a new execution of an executable. *)
module Make (E : Executable) : sig
  (** Execute the executable with the provided list of inputs. *)
  val execute : E.Input.t list -> E.Output.t list
end
