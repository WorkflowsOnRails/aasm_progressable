require 'rails/generators/base'


module AasmProgressable
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      desc 'Install a copy of the default aasm_progressable views'
      source_root File.expand_path('../../../../app/views', __FILE__)

      def copy_views
        directory 'aasm_progressable', 'app/views/aasm_progressable'
      end
    end
  end
end
