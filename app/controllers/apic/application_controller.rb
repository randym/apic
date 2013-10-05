module Apic
  class ApplicationController < ActionController::Base

    before_filter :custom_headers, :endpoints

    def index
    end

    def custom_headers
      @custom_headers ||= Apic::custom_headers
    end

    def endpoints
      @endpoints ||= Apic.endpoints
    end
  end
end
