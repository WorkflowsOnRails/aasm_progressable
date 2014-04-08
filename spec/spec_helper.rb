Bundler.require(:default, :development)

SimpleCov.start do
  add_filter "/spec/"
end

require_relative '../app/helpers/aasm_progressable/helper'
require_relative '../lib/aasm_progressable/model_mixin'
