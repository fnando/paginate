module Paginate
  class Base
    attr_accessor :options

    def initialize(options = {})
      if options.kind_of?(Hash)
        @options = options
      else
        @options = {:page => options.to_i}
      end

      @options.reverse_merge!(Paginate::Config.to_hash)
    end

    def collection_size
      @collection_size ||= options[:collection].size
    end

    def next_page?
      collection_size > options[:size]
    end

    def previous_page?
      options[:page] > 1
    end

    def page
      [1, options.fetch(:page, 1).to_i].max
    end

    def offset
      (page - 1) * (limit - 1)
    end

    def limit
      [options[:size], 10].compact.first.to_i + 1
    end

    def to_options
      { :limit => limit, :offset => offset }
    end
  end
end
