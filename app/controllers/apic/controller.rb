module Apic
  class Controller < ApplicationController


    def index
      endpoints
    end

    def endpoints
      @endpoints ||= Rails.application.routes.routes.reduce({}) do |hash, route|
        if route.path.spec.to_s =~ /\/api\//
          route_spec = {
            path: route.path.spec.to_s.gsub("(.:format)",".json"),
            parts: route.parts - [:format],
            verb: route.verb.source.gsub(/[\^\$]/,''),
            template: template_for(route.defaults[:controller], route.defaults[:action])
          }
          if %(PATCH DELETE).include? route_spec[:verb]
            route_spec[:template] = route_spec[:template] + ['_method']
          end
          if requires_authorization route.defaults[:controller], route.defaults[:action]
            route_spec[:authorization_required] = true
          end

          hash[[route_spec[:verb],route_spec[:path]].join(' ')] = route_spec
        end
        hash
      end
    end

    def requires_authorization(controller, action_name)
      controller = (controller + '_controller').camelize.constantize
      controller._process_action_callbacks.any? do |callback|
        eval <<-RUBY_EVAL
        #{callback.filter == :authenticate} && #{callback.instance_values['compiled_options']}
        RUBY_EVAL
      end
    end

    def template_for(controller, action)
      (controller + '_controller').camelize.constantize
      Apic::ParamsCache.params_for(controller, action) || []
    end
  end
end
