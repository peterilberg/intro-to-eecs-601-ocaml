open Eecs601
open Distributions
open StateMachines.Signatures

(** A stochastic model of a copy machine. *)
module CopyMachineModel = struct
  (** Actions you can perform on the copy machine. *)
  module Input = struct
    type t = Copy (** Make a copy. *)
  end

  (** What you can observe of the copy machine. *)
  module Output = struct
    type t =
      | Perfect (** A perfect copy. *)
      | Smudged (** A smudged copy. *)
      | Black (** An unusable copy. *)
  end

  (** The state of the copy machine. *)
  module State = struct
    type t =
      | Good (** Everything is fine. *)
      | Bad (** Need repair. *)
  end

  (** The probability distribution for the initial state. *)
  let initial_state = Discrete.of_list [ State.Good, 0.9; Bad, 0.1 ]

  (** The conditional distribution for observations. *)
  let observation = function
    | State.Good ->
      Discrete.of_list [ Output.Perfect, 0.8; Smudged, 0.1; Black, 0.1 ]
    | State.Bad ->
      Discrete.of_list [ Output.Perfect, 0.1; Smudged, 0.7; Black, 0.2 ]
  ;;

  (** The conditional distribution for transitions. *)
  let transition = function
    | Input.Copy ->
      (function
        | State.Good -> Discrete.of_list [ State.Good, 0.7; Bad, 0.3 ]
        | State.Bad -> Discrete.of_list [ State.Good, 0.1; Bad, 0.9 ])
  ;;
end
