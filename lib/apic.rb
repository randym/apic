require 'apic/params_cache'
require "apic/extension"
require "apic/engine"

module Apic

  mattr_accessor :authorization_filter
  @@authorization_filter = nil

  def self.endpoints
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

  def self.requires_authorization(controller, action_name)
    return false unless @@authorization_filter
    controller = (controller + '_controller').camelize.constantize
    controller._process_action_callbacks.any? do |callback|
      p @@authorization_filter
      eval <<-RUBY_EVAL
      #{callback.filter == @@authorization_filter} && #{callback.instance_values['compiled_options']}
      RUBY_EVAL
    end
  end

  def self.template_for(controller, action)
    (controller + '_controller').camelize.constantize
    Apic::ParamsCache.params_for(controller, action) || []
  end
end


