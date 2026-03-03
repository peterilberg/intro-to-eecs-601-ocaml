# Tests for uniform distributions

## Set up the environment

```ocaml
open Eecs601
open Distributions
```

```ocaml
let events = ["a1"; "a2"; "a3"; "a4"]
let distribution_a = Uniform.of_list events
```

## Tests

```ocaml
# Discrete.to_list distribution_a
- : (string * float) list =
[("a1", 0.25); ("a2", 0.25); ("a3", 0.25); ("a4", 0.25)]
```
