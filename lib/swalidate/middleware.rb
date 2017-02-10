module Swalidate
  class Middleware
    def initialize(app, options = {})
      @app = app
      @schema = Swalidate::Schema.new(options[:file_path])
      # TODO: puts a log message when not found and dont try to validate

      @subdomain   = options[:subdomain]
      @path_prefix = options[:path_prefix]
    end

    def call(env)
      @request  = ActionDispatch::Request.new(env)
      @endpoint = @schema.endpoint(@request.method, @request.path.gsub(@path_prefix.to_s, '').sub(/\.[^.]+\z/, ''))

      if should_validate?
        validator = Swalidate::Validator::Main.new(@endpoint, @request.params)
        validator.call
        return error_response(validator.errors) unless validator.valid?
      end

      @app.call(env)
    end

    private

    def error_response(errors)
      [
        400,
        { 'Content-Type' => 'application/vnd.api+json' },
        [{ errors: errors }.to_json]
      ]
    end

    def should_validate?
      valid_subdomain? && valid_path_prefix? && valid_path?
    end

    def valid_subdomain?
      @subdomain.to_s == @request.subdomain.to_s
    end

    def valid_path_prefix?
      @request.path =~ Regexp.new(@path_prefix.to_s)
    end

    def valid_path?
      @endpoint.should_validate?
    end
  end
end
