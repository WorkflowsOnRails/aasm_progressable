# @author Alexander Clelland

require 'spec_helper'

class StateKlass
  include ActiveModel::Model
  include AASM
  include AasmProgressable::ModelMixin
  attr_accessor :aasm_state
  aasm do
    state :one, initial: true
    state :two
    event :transition do
      transitions from: :one, to: :two
    end
  end
  aasm_state_order [:one, :two]
end

describe StateKlass do
  test = StateKlass.new

  it "Initial" do
    expect(test.have_not_completed? :one).to eq true
    expect(test.have_not_completed? :two).to eq true

    expect(test.have_started? :one).to eq true
    expect(test.have_not_started? :two).to eq true
  end

  test.transition #transition to state two

  it "After Transition" do
    expect(test.have_completed? :one).to eq true
    expect(test.have_not_completed? :two).to eq true

    expect(test.have_started? :one).to eq true
    expect(test.have_started? :two).to eq true
  end

end


