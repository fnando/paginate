module Paginate
  class Config
    class << self
      attr_accessor :size
      attr_accessor :param_name
      attr_accessor :renderer
    end

    def self.to_hash
      {
        size: size,
        param_name: param_name,
        renderer: renderer
      }
    end
  end
end
