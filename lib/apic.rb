require 'apic/params_cache'
require "apic/extension"
require "apic/engine"
require "apic/generators/install_generator"
require 'apic/route_wrapper'
module Apic

  mattr_accessor :authentication_filter
  @@authentication_filter = nil

  mattr_accessor :route_matcher
  @@route_matcher = /.*/

  mattr_accessor :custom_headers
  @@custom_headers = []

  class << self

    def endpoints
      @endpoints ||= endpoints_hash
    end

    private

    def endpoints_hash
      Hash.new do |hash, route|
        wrapper = RouteWrapper.new(route)
        hash[wrapper.endpoint] = wrapper.to_h unless wrapper.internal?
      end.tap do |hash|
        Rails.application.routes.routes.each do |route|
          if route.path.spec.to_s =~ @@route_matcher
            hash[route]
          end
        end
      end
    end
  end
end


