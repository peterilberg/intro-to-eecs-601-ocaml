# Tests for square distributions

## Set up the environment

```ocaml
open Eecs601
open Distributions
```

```ocaml
let distribution_a = Square.of_interval ~low:(-1) ~high:2
```

## Tests

```ocaml
# Discrete.to_list distribution_a
- : (int * float) list =
[(-1, 0.333333333333333315); (0, 0.333333333333333315);
 (1, 0.333333333333333315)]
```
