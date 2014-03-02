# Mixin for models with linear AASM-defined workflows.
#
# This mixin provides the aasm_state_order class settor, as well as
# a similarly-named instance gettor.
#
# @author Brendan MacDonell
module AasmProgressable
  module ModelMixin
    extend ActiveSupport::Concern

    # Instance gettor to return the state order for the model
    def aasm_state_order
      self.class.get_aasm_state_order
    end

    def have_completed?(state)
      current_index, target_index = state_index(self.aasm.current_state, state)
      current_index > target_index
    end

    def have_not_completed?(state)
      not have_completed?(state)
    end

    def have_started?(state)
      current_index, target_index = state_index(self.aasm.current_state, state)
      current_index >= target_index
    end

    def have_not_started?(state)
      not have_started?(state)
    end

    # Class gettors and settors for the state order
    module ClassMethods
      def aasm_state_order order
        @state_order = order
      end

      def get_aasm_state_order
        @state_order
      end
    end

    private

    # Returns an array of zero-index state indices, where each index indicates
    # the state's position in the ordered state collection.
    def state_index(*states)
      states.map { |state| self.aasm_state_order.index(state) }
    end
  end
end
