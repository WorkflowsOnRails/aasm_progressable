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
  before :each do
    @model = StateKlass.new
  end

  it "Initial" do
    expect(@model.have_not_completed? :one).to eq true
    expect(@model.have_not_completed? :two).to eq true

    expect(@model.have_started? :one).to eq true
    expect(@model.have_not_started? :two).to eq true
  end


  it "After Transition" do
    test.transition #transition to state two
    expect(@model.have_completed? :one).to eq true
    expect(@model.have_not_completed? :two).to eq true

    expect(@model.have_started? :one).to eq true
    expect(@model.have_started? :two).to eq true
  end

end
