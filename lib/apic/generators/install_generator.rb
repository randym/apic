module Apic
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../generators/templates", __FILE__)

      desc "creates initializer and add engine mount point to your routes"

      def copy_initializer
        template 'apic.rb', 'config/initializers/apic.rb'
      end

      def mount_engine
        if Rails.version < '4.0.0'
          route 'mount Apic::Engine, :at => "/apic"'
        else
          route 'mount Apic::Engine => "/apic"'
        end
      end
    end
  end
end
