open Distributions
open StateMachines
open Utilities

module Distributions = struct
  module Discrete = Discrete
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
