# Tests for conditional probability distributions

## Set up the environment

```ocaml
open Eecs601
open Distributions
```

```ocaml
# #require "ppx_deriving.ord"
```

```ocaml
let distribution_a = Discrete.of_list [("a1", 0.9); ("a2", 0.1)]
let distribution_b_given_a = function
  | "a1" -> Discrete.of_list [("b1", 0.7); ("b2", 0.3)]
  | _ -> Discrete.of_list [("b1", 0.2); ("b2", 0.8)]
let distribution_b_and_a = Conditional.join distribution_b_given_a
  ~given:distribution_a
```

```ocaml
# distribution_b_given_a "a1" |> Discrete.to_list
- : (string * float) list = [("b1", 0.7); ("b2", 0.3)]
```

```ocaml
# distribution_b_given_a "a2" |> Discrete.to_list
- : (string * float) list = [("b1", 0.2); ("b2", 0.8)]
```

```ocaml
# distribution_b_and_a |> Discrete.to_list
- : ((string * string) * float) list =
[(("b1", "a1"), 0.63); (("b2", "a1"), 0.27);
 (("b1", "a2"), 0.0200000000000000039);
 (("b2", "a2"), 0.0800000000000000155)]
```

```ocaml
type disease = Sick | Healthy [@@deriving ord]
type test = Positive | Negative [@@deriving ord]

let distribution_disease = Discrete.of_list [(Sick, 0.001); (Healthy, 0.999)]

let distribution_test_given_disease = function
  | Sick -> Discrete.of_list [(Positive, 0.990); (Negative, 0.010)]
  | Healthy -> Discrete.of_list [(Positive, 0.001); (Negative, 0.999)]
```

```ocaml
# Conditional.bayesian_evidence distribution_test_given_disease
  ~prior: distribution_disease ~evidence:Positive
  |> Discrete.to_list
- : (disease * float) list =
[(Sick, 0.49773755656108587); (Healthy, 0.502262443438914)]
```

```ocaml
# Conditional.total_probability distribution_test_given_disease
  ~prior: distribution_disease
  |> Discrete.condense ~compare:compare_test
  |> Discrete.to_list
- : (test * float) list =
[(Positive, 0.00198900000000000032); (Negative, 0.998011)]
```
