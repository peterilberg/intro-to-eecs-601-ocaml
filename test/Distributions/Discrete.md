# Tests for discrete probability distributions

## Set up the environment

```ocaml
open IntroToEeAndCsWithOcaml
open Distributions
```

```ocaml
# #require "ppx_deriving.ord"
# type test = A | B | C [@@deriving ord]
type test = A | B | C
val compare_test : test -> test -> int = <fun>
```

```ocaml
# A
- : test = A
```

```ocaml
let events = [("a1", 0.9); ("a2", 0.1)]
let distribution_a = Discrete.create ~events ~compare:String.compare
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
module Table = Hashtbl.Make(String)

let sample ~seed ~distribution =
  let table = events
    |> List.map (fun (event, _) -> (event, 0))
    |> List.to_seq
    |> Table.of_seq in
  Random.init seed;
  for i = 1 to 100 do
    let event = Discrete.draw ~distribution in
    Table.replace table event (1 + Table.find table event)
  done;
  table |> Table.to_seq |> List.of_seq
```

```ocaml
# sample ~seed:42 ~distribution:distribution_a
- : (string * int) list = [("a2", 11); ("a1", 89)]
```

```ocaml
type joint = string * string [@@deriving ord]
let events = [
  (("a1", "b1"), 0.63);
  (("a1", "b2"), 0.27);
  (("a2", "b1"), 0.02);
  (("a2", "b2"), 0.08)
]
let distribution_a_and_b = Discrete.create ~events ~compare:compare_joint
```

```ocaml
# Discrete.marginalize
  ~distribution:distribution_a_and_b
  ~convert:(fun (a, _) -> Some a)
  ~compare:String.compare
  |> Discrete.to_list
- : (string * float) list = [("a1", 0.9); ("a2", 0.1)]
```

```ocaml
# Discrete.marginalize
  ~distribution:distribution_a_and_b
  ~convert:(fun (_, b) -> Some b)
  ~compare:String.compare
  |> Discrete.to_list
- : (string * float) list = [("b1", 0.65); ("b2", 0.350000000000000033)]
```

```ocaml
# Discrete.marginalize
  ~distribution:distribution_a_and_b
  ~convert:(fun (a, b) -> if b = "b1" then Some a else None)
  ~compare:String.compare
  |> Discrete.to_list
- : (string * float) list =
[("a1", 0.969230769230769229); ("a2", 0.0307692307692307675)]
```
