module Apic
  class ParamsCache
    class << self
      def add_action_params(cclass, actions)
        action_params[cclass.name.underscore.gsub('_controller', '')] = actions
      end

      def action_params
        @action_params ||= {}
      end

      def params_for(controller, action)
        if controller = action_params[controller]
          controller[action.to_sym]
        end
      end
    end
  end
end
