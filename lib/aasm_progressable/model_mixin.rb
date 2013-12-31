# TODO
#
# @author Brendan MacDonell
module AasmProgressable
  module ModelMixin
    extend ActiveSupport::Concern

    def aasm_state_order
      self.class.get_aasm_state_order
    end

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
