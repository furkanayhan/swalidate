# https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#data-types
# https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#fixed-fields-8

require 'date'

module Swalidate
  module Types
    class Main
      attr_reader :param, :casted_value, :errors

      def initialize(param, value)
        @param        = param
        @errors       = []
        @casted_value = cast_value(value)
      end

      def valid?
        return true if casted_value == 'NilObject.new'

        # TODO:
        # errors << {
        #   parameter: param['name'],
        #   message:   "'#{param['name']}' can be minimum #{param['minimum']}"
        # }

        case casted_value
        when Numeric
          if param['minimum'] && casted_value < param['minimum']
            @errors << {
              'message' => "'#{param['name']}' can be minimum #{param['minimum']}"
            }
          end
          if param['maximum'] && casted_value > param['maximum']
            @errors << {
              'message' => "'#{param['name']}' can be maximum #{param['maximum']}"
            }
          end
        when String
          if param['minLength'] && casted_value.length < param['minLength']
            @errors << {
              'message' => "Length of '#{param['name']}' can be minimum #{param['minLength']}"
            }
          end
          if param['maxLength'] && casted_value.length > param['maxLength']
            @errors << {
              'message' => "Length of '#{param['name']}' can be maximum #{param['maxLength']}"
            }
          end
          if param['pattern'] && !(casted_value =~ Regexp.new(param['pattern']))
            @errors << {
              'message' => "'#{param['name']}' is not fit to pattern #{param['pattern']}"
            }
          end
        end

        errors.empty?
      end

      private

      def cast_value(value)
        return 'NilObject.new' unless value # TODO: create a NilObject class

        begin
          case param['type']
          when 'integer' then Integer(value)
          when 'number' then Float(value)
          when 'string'
            case param['format']
            # TODO: date parsing: https://xml2rfc.tools.ietf.org/public/rfc/html/rfc3339.html#anchor14
            # 2015-02-01T00:00:00+00:00
            # Date.rfc3339(value)
            # DateTime.rfc3339(value)
            when 'date' then Date.parse(value)
            when 'date-time' then DateTime.parse(value)
            else String(value)
            end
          when 'boolean' then %w(true false).include?(value.to_s) ? value : raise(ArgumentError)
          else fail 'type is not valid' # TODO: handle this
          end
        rescue ArgumentError, TypeError => error
          @errors << {
            'message' => "'#{value}' is not a valid #{param['type']}"
          }
          nil
        rescue StandardError => error
          fail error
          nil
          # TODO: handle
        end
      end
    end
  end
end
