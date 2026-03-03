(** An executable. *)
module type Executable = sig
  module Input : sig
    type t
  end

  module Output : sig
    type t
  end

  module State : sig
    type t
  end

  (** Start execution. *)
  val start : unit -> State.t

  (** Advance execution one step. *)
  val step : int -> State.t -> Input.t -> State.t * Output.t

  (** Finish execution. *)
  val finish : Output.t list -> Output.t list
end
