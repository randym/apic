module Apic
  class Controller < ApplicationController
    def index
      endpoints
    end

    def endpoints
      @endpoints ||= Rails.application.routes.routes.reduce([]) do |array, route|
        if route.path.spec.to_s =~ /\/api\//
          route_spec = {
            path: route.path.spec.to_s.gsub("(.:format)",".json"),
            parts: route.parts - [:format],
            verb: route.verb.source.gsub(/[\^\$]/,''),
            template: template_for(route.defaults[:controller], route.defaults[:action])
          }
          array.push route_spec
        end
        array
      end
    end

    def template_for(controller, action)
      (controller + '_controller').camelize.constantize
      p Apic::ParamsCache.action_params
      Apic::ParamsCache.params_for(controller, action) || []
    end
  end
end
