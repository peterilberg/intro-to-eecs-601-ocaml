# Tests for the Accumulator state machine

## Set up the environment

```ocaml
# #require "intro_to_ee_and_cs_with_ocaml"
```

```ocaml
open IntroToEeAndCsWithOcaml
```

```ocaml
module Accumulator = StateMachines.Accumulator
module Machine = StateMachines.Accumulator.Make (Int)
module Execution = StateMachine.Execution.Make (Machine)
```

```ocaml
let value_to_string value = Int.to_string value

let list_to_string list =
  let items = List.map value_to_string list in
  "[" ^ String.concat ", " items ^ "]"

let trace =
  let trace_start state =
    Printf.printf "Start state: %s\n" (value_to_string state)
  in
  let trace_step i _ input output state =
    Printf.printf
      "%d: input %s produces %s with new state: %s\n"
      i
      (value_to_string input)
      (value_to_string output)
      (value_to_string state)
  in
  let trace_result result =
    Printf.printf "Output: %s\n" (list_to_string result)
  in
  Execution.trace ~trace_start ~trace_step ~trace_result
```

## Tests

```ocaml
# let accumulator = Machine.create ~initial_value:0 in
  let execution = Execution.create ~machine:accumulator in
  let inputs = [ 100; -3; 4; -123; 10 ] in
  Execution.run ~execution ~inputs
- : int list = [100; 97; 101; -22; -12]
```

```ocaml
# let accumulator = Machine.create ~initial_value:0 in
  let execution = Execution.create ~machine:accumulator in
  let execution = trace ~execution in
  let inputs = [ 100; -3; 4; -123; 10 ] in
  Execution.run ~execution ~inputs
Start state: 0
0: input 100 produces 100 with new state: 100
1: input -3 produces 97 with new state: 97
2: input 4 produces 101 with new state: 101
3: input -123 produces -22 with new state: -22
4: input 10 produces -12 with new state: -12
Output: [100, 97, 101, -22, -12]
- : int list = [100; 97; 101; -22; -12]
```
