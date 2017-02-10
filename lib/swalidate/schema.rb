module Swalidate
  class Schema
    attr_reader :paths, :definitions

    def initialize(file_path)
      swagger      = Swagger.load(file_path)
      # TODO: error handling for files

      @paths       = swagger.paths
      @definitions = swagger.definitions
    end

    def endpoint(method, path)
      Swalidate::Endpoint.new(paths[path] && paths[path][method.downcase])
    end
  end
end
