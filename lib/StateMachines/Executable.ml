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

  val start : unit -> State.t
  val step : int -> State.t -> Input.t -> State.t * Output.t
  val finish : Output.t list -> Output.t list
end

