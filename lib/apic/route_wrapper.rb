require 'delegate'

module Apic
  class RouteWrapper < SimpleDelegator

    def to_h
      endpoint = {
        path: path,
        parts: parts - [:format],
        verb: verb,
        template: template,
        key: key,
        authentication_required: authentication_required
      }

      if %(PATCH DELETE).include? verb
        endpoint[:template] << '_method'
      end

      endpoint
    end

    def endpoint
      [verb, path].join(' ')
    end

    def internal?
      requirements[:controller].to_s =~ %r{\Arails/(info|welcome)} ||
        path =~ %r{\A#{Rails.application.config.assets.prefix}} ||
        path =~ %r{\A\/apic}
    end

  private

    def authentication_required
      return false unless Apic.authentication_filter
      controller._process_action_callbacks.any? do |callback|
        eval <<-RUBY_EVAL
        #{callback.filter == Apic.authentication_filter} && #{callback.instance_values['compiled_options']}
        RUBY_EVAL
      end
    end

    def controller
      if controller = requirements[:controller]
        [controller.to_s, 'controller'].join('_').camelize.constantize
      end
    end

    def verb
      super.source.gsub(/[$^]/, '')
    end

    def path
      super.spec.to_s.gsub("(.:format)",".json")
    end

    def action_name
      requirements[:action]
    end

    def key
      [verb, path].join(' ')
    end

    def template
      Apic::ParamsCache.params_for(controller, action_name) || []
    end
  end
end
