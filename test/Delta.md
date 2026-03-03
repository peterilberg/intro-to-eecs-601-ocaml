# Tests for delta distributions

## Set up the environment

```ocaml
open Eecs601
open Distributions
```

```ocaml
let distribution_x = Delta.of_event "x"
```

## Tests

```ocaml
# Discrete.to_list distribution_x
- : (string * float) list = [("x", 1.)]
```
