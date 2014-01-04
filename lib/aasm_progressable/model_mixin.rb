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

    # Class gettors and settors for the state order
    module ClassMethods
      def aasm_state_order order
        @state_order = order
      end

      def get_aasm_state_order
        @state_order
      end
    end
  end
end
