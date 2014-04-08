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
    attr_reader :id      # the internal ID for the state (as a string)
    attr_reader :name    # name displayed to the user

    def initialize(id, name, status_classes)
      @id = id.to_s
      @name = name
      @status_classes = status_classes
    end

    # html_class may contain complete, previous, active, next, or incomplete.
    def html_class
      @status_classes.join(' ')
    end

    def is?(status_class)
      @status_classes.include? status_class
    end

    # Returns an Array of State instances corresponding to the states
    # of a model instance. The State instances are returned in the order
    # given by the `aasm_state_order` declaration in the model.
    def self.create_all(object)
      localizer = AASM::Localizer.new
      state_order = object.aasm_state_order
      current_state = object.aasm.current_state

      current_state_index = state_order.index(current_state)

      object.aasm_state_order.each_with_index.map do |state, index|
        status_classes = []
        status_classes << :complete if index < current_state_index
        status_classes << :previous if index == current_state_index - 1
        status_classes << :active if index == current_state_index
        status_classes << :next if index == current_state_index + 1
        status_classes << :incomplete if index > current_state_index

        name = localizer.human_state_name(object.class, state)
        State.new(state, name, status_classes)
      end
    end
  end

  module Helper
    # Renders a state indicator for a specified model instance.
    def render_state_indicator(object, locals: {})
      states = State.create_all(object)
      locals = {states: states}.merge(locals)
      rendered = render partial: 'aasm_progressable/states/list', locals: locals
      rendered.html_safe
    end
  end
end
