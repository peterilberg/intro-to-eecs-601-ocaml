# Tests for stochastic state machines

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
Random.init 42;;

let action = CopyMachineModel.Input.Copy
let inputs = Seq.init 20 (Fun.const action) |> List.of_seq

module CopyMachine = Run.Make (Stochastic.Make (CopyMachineModel))
```

```ocaml
# CopyMachine.run inputs
- : CopyMachineModel.Output.t list =
[CopyMachineModel.Output.Perfect; CopyMachineModel.Output.Perfect;
 CopyMachineModel.Output.Perfect; CopyMachineModel.Output.Perfect;
 CopyMachineModel.Output.Smudged; CopyMachineModel.Output.Smudged;
 CopyMachineModel.Output.Smudged; CopyMachineModel.Output.Smudged;
 CopyMachineModel.Output.Perfect; CopyMachineModel.Output.Smudged;
 CopyMachineModel.Output.Smudged; CopyMachineModel.Output.Smudged;
 CopyMachineModel.Output.Black; CopyMachineModel.Output.Smudged;
 CopyMachineModel.Output.Smudged; CopyMachineModel.Output.Perfect;
 CopyMachineModel.Output.Smudged; CopyMachineModel.Output.Smudged;
 CopyMachineModel.Output.Smudged; CopyMachineModel.Output.Smudged]
```
