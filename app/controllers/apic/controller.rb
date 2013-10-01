module Apic
  class Controller < ApplicationController


    def index
      endpoints
    end

    def endpoints
      @endpoints ||= Apic.endpoints
    end
  end
end
