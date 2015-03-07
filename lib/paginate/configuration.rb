module Paginate
  class Configuration
    attr_accessor :size
    attr_accessor :param_name
    attr_accessor :renderer

    def initialize
      @param_name = :page
      @size  = 10
      @renderer = Renderer::List
    end

    def to_hash
      {
        size: size,
        param_name: param_name,
        renderer: renderer
      }
    end
  end
end
