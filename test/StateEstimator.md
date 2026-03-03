# Tests for state estimation state machines

## Set up the environment

```ocaml
open Eecs601
open Distributions
open StateMachines
```

```ocaml
# #use "CopyMachineModel.ml"
module CopyMachineModel :
  sig
    module Input : sig type t = Copy end
    module Output : sig type t = Perfect | Smudged | Black end
    module State : sig type t = Good | Bad end
    val initial_state : State.t Discrete.t
    val observation : State.t -> Output.t Discrete.t
    val transition : Input.t -> State.t -> State.t Discrete.t
  end
```

```ocaml
# #require "ppx_deriving.ord"
```

```ocaml
type state = CopyMachineModel.State.t =
  | Good
  | Bad [@@deriving ord]
```

```ocaml
Random.init 42;;

let inputs = CopyMachineModel.([
  (Input.Copy, Output.Perfect);
  (Input.Copy, Output.Smudged)
])

module CopyMachine = Run.Make (StateEstimator.Make (CopyMachineModel))
```

## Tests

```ocaml
# CopyMachine.run inputs
  |> List.map (Discrete.merge_events ~compare:compare_state)
  |> List.map Discrete.to_list
- : (state * float) list list =
[[(Good, 0.986301369863013644); (Bad, 0.0136986301369863023)];
 [(Good, 0.242788461538461564); (Bad, 0.757211538461538436)]]
```
