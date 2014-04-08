# @author Alexander Clelland

require 'spec_helper'

class Fake
  include ActiveModel::Model

  include AASM
  include AasmProgressable::ModelMixin

  attr_accessor :aasm_state

  aasm do
    state :one, initial: true
    state :two

    event :foo do
      transitions from: :one, to: :two
    end
  end

  aasm_state_order [:one, :two]

end

describe "blah" do
  @blah = Fake.new

  binding.pry

  #render_state_indicator(@blah)

end
