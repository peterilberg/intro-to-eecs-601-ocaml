# Tests for mixed distributions

## Set up the environment

```ocaml
open Eecs601
open Distributions
```

```ocaml
let triangle = Triangle.of_triangle ~peak:3 ~half_width:1
let square = Square.of_interval ~low:0 ~high:3
let distribution = Mixed.of_distributions triangle square ~mix:0.3
```

```ocaml
# Discrete.to_list distribution
- : (int * float) list =
[(0, 0.233333333333333337); (1, 0.233333333333333337);
 (2, 0.308333333333333348); (3, 0.150000000000000022);
 (4, 0.0750000000000000111)]
```
