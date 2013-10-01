module Apic
  class ApplicationController < ActionController::Base
    def index
      endpoints
    end

    def endpoints
      @endpoints ||= Apic.endpoints
    end
  end
end
