# [cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn support_of_distribution_a() {
        let d_a = distribution_a();
        let mut support: Vec<_> = d_a.support().collect();
        support.sort();
        assert_eq!(support, [&"a1", &"a2"]);
    }

    #[test]
    fn probability_of_events_in_distribution_a() {
        let d_a = distribution_a();
        assert_eq!(d_a.probability(&"a1"), 0.9);
        assert_eq!(d_a.probability(&"a2"), 0.1);
    }

    #[test]
    fn draw_from_distribution_a() {
        let d_a = distribution_a();
        let mut results = HashMap::new();
        for _ in 1..=100 {
            let event = *d_a.draw();
            *results.entry(event).or_insert(0) += 1;
        }
        assert!(results["a1"] > results["a2"]);
    }

    #[test]
    fn marginalize_distribution_without_a() {
        assert_eq!(
            distribution_a_and_b().marginalize(|(_, b)| *b),
            Discrete::from([("b1", 0.65), ("b2", 0.35),])
        )
    }

    #[test]
    fn marginalize_distribution_without_b() {
        assert_eq!(
            distribution_a_and_b().marginalize(|(a, _)| *a),
            Discrete::from([("a1", 0.90), ("a2", 0.10),])
        )
    }

    #[test]
    fn conditional_distribution_to_b1() {
        assert_eq!(
            distribution_a_and_b()
                .condition(|(_, b)| b == &"b1")
                .marginalize(|(a, _)| *a),
            Discrete::from([("a1", 0.97), ("a2", 0.03),])
        )
    }

    type A = &'static str;
    type B = &'static str;

    fn distribution_a() -> Discrete<A> {
        Discrete::from([("a1", 0.9), ("a2", 0.1)])
    }

    fn distribution_a_and_b() -> Discrete<(A, B)> {
        Discrete::from([
            (("a1", "b1"), 0.63),
            (("a1", "b2"), 0.27),
            (("a2", "b1"), 0.02),
            (("a2", "b2"), 0.08),
        ])
    }
}
