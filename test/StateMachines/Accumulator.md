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
module Run = StateMachine.Execution.Run (Machine)
module Transitions = StateMachine.Execution.Transitions (Machine)
module Trace = StateMachine.Execution.Trace (Machine) (Int) (Int) (Int)
```

## Tests

```ocaml
let inputs = [ 100; -3; 4; -123; 10 ]
```

```ocaml
# Run.run inputs
- : int list = [100; 97; 101; -22; -12]
```

```ocaml
# Trace.run inputs
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
# Transitions.run inputs
- : Transitions.transition list =
[{Transitions.n = 0; old_state = 0; new_state = 100; input = 100;
  output = 100};
 {Transitions.n = 1; old_state = 100; new_state = 97; input = -3;
  output = 97};
 {Transitions.n = 2; old_state = 97; new_state = 101; input = 4;
  output = 101};
 {Transitions.n = 3; old_state = 101; new_state = -22; input = -123;
  output = -22};
 {Transitions.n = 4; old_state = -22; new_state = -12; input = 10;
  output = -12}]
```
