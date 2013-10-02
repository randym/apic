module Apic
  class ApplicationController < ActionController::Base
    def index
      Rails.logger.debug endpoints
      endpoints
    end

    def endpoints
      @endpoints ||= Apic.endpoints
    end
  end
end
