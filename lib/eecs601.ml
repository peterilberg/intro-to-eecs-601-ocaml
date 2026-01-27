open Distributions
open StateMachines
open Utilities

module Distributions = struct
  module Discrete = Discrete
  module Delta = Delta
  module Mixed = Mixed
  module Square = Square
  module Triangle = Triangle
  module Uniform = Uniform
  (*  module Conditional = Conditional *)
end

module StateMachines = struct
  module Signatures = struct
    module type StateMachine = StateMachine.StateMachine
  end

  module Run = Run
  module Trace = Trace
  module Transitions = Transitions
  module Accumulator = Accumulator
end

module Utilities = struct
  module Signatures = struct
    module type Addable = Addable.Addable
    module type Printable = Printable.Printable
  end
end
