(** A discrete probability distribution. *)
type 'a t

(** Create a new discrete distribution from a list of events and
    probabilities. *)
val of_list : ('a * float) list -> 'a t

(** Get the events and probabilities in a discrete distribution. *)
val to_list : 'a t -> ('a * float) list

(** The [support] of a discrete distribution are the events. *)
val support : 'a t -> 'a list

(** Get the [probability] of an event in a discrete distribution. *)
val probability : 'a t -> 'a -> float

(** Randomly [draw] an event from the discrete distribution. *)
val draw : 'a t -> 'a

(** Marginalize a distribution by converting source events to
    target events. You may also filter events (conditioning). *)
val marginalize : 'a t -> convert:('a -> 'b option) -> 'b t

(** [marginalize] may result in multiple entries for an event in the
    resulting distribution. All operations will still function correctly,
    but they may be slower than necessary. You may also want to merge
    multiple entries before converting [to_list]. *)
val merge_events : 'a t -> compare:('a -> 'a -> int) -> 'a t

(** Randomly [draw] multiple samples from a distribution. *)
val sample : 'a t -> int -> 'a array

(** Tally the results of [sample]. *)
val tally : compare:('a -> 'a -> int) -> 'a array -> ('a * int) list
