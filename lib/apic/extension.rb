module Apic
  module Extension
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def apic_action_params(actions)
        Apic::ParamsCache.add_action_params(self, actions)
      end
    end
  end
end
