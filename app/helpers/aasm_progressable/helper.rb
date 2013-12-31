#
#
# @author Brendan MacDonell
module AasmProgressable
  class State
    #
    attr_reader :name
    attr_reader :status

    def initialize(name, status)
      @name = name
      @status = status
    end

    def self.create_all(object)
      localizer = AASM::Localizer.new
      found_current_state = false

      #
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
    # ...
    #
    # @author Brendan MacDonell
    def render_state_indicator(object)
      states = State.create_all(object)
      rendered = render partial: 'aasm_progressable/states/list',
                        locals: {states: states}
      rendered.html_safe
    end
  end
end
