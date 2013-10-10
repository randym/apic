module Apic
  class Engine < ::Rails::Engine
    isolate_namespace Apic
    ActiveSupport.on_load(:action_controller) do
      ActionController::Base.send(:include, Apic::Extension)
    end
  end
end
