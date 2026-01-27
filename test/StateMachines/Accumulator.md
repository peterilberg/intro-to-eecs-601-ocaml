# Tests for the Accumulator state machine

## Set up the environment

```ocaml
open IntroToEeAndCsWithOcaml
```

```ocaml
module Accumulator = StateMachines.Accumulator
module Machine = StateMachines.Accumulator.Make
  (Int)
  (struct
    let initial_value = 0
   end)
module Execution = StateMachine.Execution.Make (Machine)
```

```ocaml
module Trace = Execution.Trace (Int) (Int) (Int)
```

## Tests

```ocaml
let inputs = [ 100; -3; 4; -123; 10 ]
```

```ocaml
# Execution.run ~inputs
- : int list = [100; 97; 101; -22; -12]
```

```ocaml
# Trace.run ~inputs
Start state: 0
0: input 100 produces 100 with new state: 100
1: input -3 produces 97 with new state: 97
2: input 4 produces 101 with new state: 101
3: input -123 produces -22 with new state: -22
4: input 10 produces -12 with new state: -12
Output: [100, 97, 101, -22, -12]
- : int list = [100; 97; 101; -22; -12]
```

```ocaml
# Execution.transitions ~inputs
- : Execution.transition list =
[{Execution.step = 0; from_state = 0; to_state = 100; input = 100;
  output = 100};
 {Execution.step = 1; from_state = 100; to_state = 97; input = -3;
  output = 97};
 {Execution.step = 2; from_state = 97; to_state = 101; input = 4;
  output = 101};
 {Execution.step = 3; from_state = 101; to_state = -22; input = -123;
  output = -22};
 {Execution.step = 4; from_state = -22; to_state = -12; input = 10;
  output = -12}]
```
