module Swalidate
  module Validator
    class Parameter
      attr_reader :param, :value, :type

      def initialize(param, value)
        @param = param
        @value = value
        @type  = Swalidate::Types::Main.new(param, value)
      end

      def valid?
        return false if required? && !exists?

        if exists?
          type.valid?
        else
          !required?
        end
      end

      def errors
        if exists?
          type.errors
        else
          required? ? ["'#{param['name']}' can't be blank."] : []
        end
      end

      def invalid?
        !valid?
      end

      def required?
        param['required']
      end

      def exists?
        !!value
      end
    end
  end
end
