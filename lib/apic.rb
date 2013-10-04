require 'apic/params_cache'
require "apic/extension"
require "apic/engine"
require "apic/generators/install_generator"
module Apic

  mattr_accessor :authentication_filter
  @@authentication_filter = nil

  mattr_accessor :route_matcher
  @@route_matcher = /\/api\//



  def self.endpoints
    @endpoints ||= Rails.application.routes.routes.reduce({}) do |hash, route|
      if route.path.spec.to_s =~ @@route_matcher
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
    return false unless @@authentication_filter
    controller = (controller + '_controller').camelize.constantize
    controller._process_action_callbacks.any? do |callback|
      eval <<-RUBY_EVAL
      #{callback.filter == @@authentication_filter} && #{callback.instance_values['compiled_options']}
      RUBY_EVAL
    end
  end

  def self.template_for(controller, action)
    (controller + '_controller').camelize.constantize
    Apic::ParamsCache.params_for(controller, action) || []
  end
end


