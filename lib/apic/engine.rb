module Apic
  class Engine < ::Rails::Engine
    isolate_namespace Apic
    require 'jquery-rails'
    require 'bootstrap-sass'
    ActiveSupport.on_load(:action_controller) do
      ActionController::Base.send(:include, Apic::Extension)
    end
  end
end

