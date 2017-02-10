module Swalidate
  class Endpoint
    attr_reader :parameters

    def initialize(detail)
      @parameters = Array(detail && detail['parameters'])
    end

    def should_validate?
      @parameters.any?
    end
  end
end
