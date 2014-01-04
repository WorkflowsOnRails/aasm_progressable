# The ActionView helper. This should be made accessible to appropriate
# controllers by adding a `helper AasmProgressable::Helper` declaration
# to them.
#
# @author Brendan MacDonell
module AasmProgressable
  # Internal class to manage display attribute associated with each
  # model state, such as the name to display, and if the state has
  # been completed yet or not.
  class State
    attr_reader :name    # name displayed to the user
    attr_reader :status  # :complete, :active, or :incomplete

    def initialize(name, status)
      @name = name
      @status = status
    end

    # Returns an Array of State instances corresponding to the states
    # of a model instance. The State instances are returned in the order
    # given by the `aasm_state_order` declaration in the model.
    def self.create_all(object)
      localizer = AASM::Localizer.new

      # Have we reached the current state yet?
      #  Completed states precede the current state, so this is
      #  the inverse of `is this state completed`
      found_current_state = false

      object.aasm_state_order.map do |state|
        is_current_state = state == object.aasm.current_state
        found_current_state = true if is_current_state

        status =
          if is_current_state
            :active
          elsif found_current_state
            :incomplete
          else
            :complete
          end

        name = localizer.human_state_name(object.class, state)
        State.new(name, status)
      end
    end
  end

  module Helper
    # Renders a state indicator for a specified model instance.
    def render_state_indicator(object)
      states = State.create_all(object)
      rendered = render partial: 'aasm_progressable/states/list',
                        locals: {states: states}
      rendered.html_safe
    end
  end
end
