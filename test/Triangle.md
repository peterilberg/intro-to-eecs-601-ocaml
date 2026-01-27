# Tests for delta distributions

## Set up the environment

```ocaml
open Eecs601
open Distributions
```

```ocaml
let distribution_1 = Triangle.of_triangle ~peak:0 ~half_width:2
let distribution_2 = Triangle.of_triangle ~peak:3 ~half_width:2
let distribution_3 = Triangle.of_triangle ~peak:3 ~half_width:1
```

```ocaml
# Discrete.to_list distribution_1
- : (int * float) list =
[(-2, 0.111111111111111105); (-1, 0.22222222222222221);
 (0, 0.333333333333333315); (1, 0.22222222222222221);
 (2, 0.111111111111111105)]
```

```ocaml
# Discrete.to_list distribution_2
- : (int * float) list =
[(1, 0.111111111111111105); (2, 0.22222222222222221);
 (3, 0.333333333333333315); (4, 0.22222222222222221);
 (5, 0.111111111111111105)]
```

```ocaml
# Discrete.to_list distribution_3
- : (int * float) list = [(2, 0.25); (3, 0.5); (4, 0.25)]
```
