module Swalidate
  module Validator
    class Main
      attr_reader :endpoint_params, :request_params, :errors

      def initialize(endpoint, request_params)
        @endpoint_params = endpoint.parameters
        @request_params  = request_params
        @errors          = []
      end

      def call
        # TODO: allow extra parameters?
        endpoint_params.each do |param|
          parameter = Swalidate::Validator::Parameter.new(param, request_params[param['name']])
          if parameter.invalid?
            @errors += parameter.errors
          end
        end
      end

      def valid?
        errors.empty?
      end

      def invalid?
        !valid?
      end
    end
  end
end
