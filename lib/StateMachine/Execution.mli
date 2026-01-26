open Interfaces

module Make (M : Machine) : sig
  type t

  val create : machine:M.t -> t
  val run : execution:t -> inputs:M.Input.t list -> M.Output.t list

  val trace
    :  trace_start:(M.State.t -> unit)
    -> trace_step:
         (int -> M.State.t -> M.Input.t -> M.Output.t -> M.State.t -> unit)
    -> trace_result:(M.Output.t list -> unit)
    -> execution:t
    -> t

  type transition =
    { step : int
    ; from_state : M.State.t
    ; to_state : M.State.t
    ; input : M.Input.t
    ; output : M.Output.t
    }

  val trajectory : execution:t -> inputs:M.Input.t list -> transition list
end
