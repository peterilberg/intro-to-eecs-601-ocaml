open Interfaces

module Make (M : Machine) : sig
  type t

  val create : machine:M.t -> t
  val run : execution:t -> inputs:M.input list -> M.output list

  val trace
    :  trace_start:(M.state -> unit)
    -> trace_step:(int -> M.state -> M.input -> M.output -> M.state -> unit)
    -> trace_result:(M.output list -> unit)
    -> execution:t
    -> t
end
