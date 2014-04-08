# @author Alexander Clelland

require 'spec_helper'

class Fake < ActiveRecord::Base
  include AASM
  include AasmProgressable::ModelMixin

  aasm do
    state :one, initial: true
    state :two
  end

  aasm_state_order [:one, :two]

end

describe "blah" do
  @blah = Fake.new
  #render_state_indicator(@blah)

end




