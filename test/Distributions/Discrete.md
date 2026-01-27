# Tests for discrete probability distributions

## Set up the environment

```ocaml
open Eecs601
open Distributions
```

Currently, the tests do not need `[@@deriving ord]`.
We keep it if they need it in the future.

```ocaml
# #require "ppx_deriving.ord"
```

```ocaml
let events = [("a1", 0.9); ("a2", 0.1)]
let distribution_a = Discrete.of_list events
```

```ocaml
# Discrete.support ~distribution:distribution_a
- : string list = ["a1"; "a2"]
```

```ocaml
# Discrete.probability ~distribution:distribution_a ~event:"a1"
- : float = 0.9
# Discrete.probability ~distribution:distribution_a ~event:"a2"
- : float = 0.1
```

```ocaml
Random.init 42
```

```ocaml
# Discrete.sample ~n:100 ~distribution:distribution_a
  |> Discrete.tally ~compare:String.compare
- : (string * int) list = [("a1", 89); ("a2", 11)]
```

```ocaml
let events = [
  (("a1", "b1"), 0.63);
  (("a1", "b2"), 0.27);
  (("a2", "b1"), 0.02);
  (("a2", "b2"), 0.08)
]
let distribution_a_and_b = Discrete.of_list events
```

```ocaml
# Discrete.marginalize
  ~distribution:distribution_a_and_b
  ~convert:(fun (a, _) -> Some a)
  |> Discrete.to_list
- : (string * float) list =
[("a1", 0.63); ("a1", 0.27); ("a2", 0.02); ("a2", 0.08)]
```

```ocaml
# Discrete.marginalize
  ~distribution:distribution_a_and_b
  ~convert:(fun (_, b) -> Some b)
  |> Discrete.to_list
- : (string * float) list =
[("b1", 0.63); ("b2", 0.27); ("b1", 0.02); ("b2", 0.08)]
```

```ocaml
# Discrete.marginalize
  ~distribution:distribution_a_and_b
  ~convert:(fun (a, b) -> if b = "b1" then Some a else None)
  |> Discrete.to_list
- : (string * float) list =
[("a1", 0.969230769230769229); ("a2", 0.0307692307692307675)]
```
