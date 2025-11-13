module type Accumulable = sig
  type t

  val accumulate : t -> t -> t
end

module Make (A : Accumulable) = struct
  let make_with ~initial_value =
    let get_start_state () = initial_value in
    let get_next_state s i =
      let sum = A.accumulate s i in
      sum, sum
    in
    StateMachine.make_with ~get_start_state ~get_next_state
  ;;
end
