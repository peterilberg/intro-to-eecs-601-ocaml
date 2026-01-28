open Eecs601
open Distributions
open StateMachines.Signatures

module CopyMachineModel = struct
  module Input = struct
    type t = Copy
  end

  module Output = struct
    type t =
      | Perfect
      | Smudged
      | Black
  end

  module State = struct
    type t =
      | Good
      | Bad
  end

  let initial_state = Discrete.of_list [ State.Good, 0.9; Bad, 0.1 ]

  let observation = function
    | State.Good ->
      Discrete.of_list [ Output.Perfect, 0.8; Smudged, 0.1; Black, 0.1 ]
    | State.Bad ->
      Discrete.of_list [ Output.Perfect, 0.1; Smudged, 0.7; Black, 0.2 ]
  ;;

  let transition = function
    | Input.Copy ->
      (function
        | State.Good -> Discrete.of_list [ State.Good, 0.7; Bad, 0.3 ]
        | State.Bad -> Discrete.of_list [ State.Good, 0.1; Bad, 0.9 ])
  ;;
end
