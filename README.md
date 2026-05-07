# Overview

The code and the projects in this repository are based on the material for
MIT's course [EE 6.01 (2011) "Introduction to Electrical Engineering and
Computer Science I"](https://ocw.mit.edu/courses/6-01sc-introduction-to-electrical-engineering-and-computer-science-i-spring-2011/).

The course explains concepts such as state machines and probability with
accompanying Python code and exercises. I have reimplemented some of the
projects in Ocaml as an exercise.

## Building

Install dependencies:

    opam install mdx ppx_deriving

Build and run tests:

    dune clean
    dune build
    dune test

## Use

Look at the tests for examples on how to use these tools. In particular,
look at `Accumulator`, `Stochastic` and `StateEstimator`.
