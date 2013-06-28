module Paginate
  module Renderer
    class Base
      attr_reader :options, :current_page, :view_context

      def initialize(view_context, options)
        @view_context = view_context
        @current_page = [options[:page].to_i, 1].max
        options.reverse_merge!(Paginate::Config.to_hash)
        @options = options.merge(page: current_page)
      end

      def processor
        @processor ||= Paginate::Base.new(nil, options)
      end

      def previous_url
        url_for(options[:page] - 1)
      end

      def next_url
        url_for(options[:page] + 1)
      end

      def url_for(page)
        url = options[:url] || options[:fullpath]

        if url.respond_to?(:call)
          url = url.call(page).to_s.dup
        else
          url = url.dup

          re = Regexp.new("([&?])#{Regexp.escape(options[:param_name].to_s)}=[^&]*")
          url.gsub!(re, "\\1")
          url.gsub!(/[\?&]$/, "")
          url.gsub!(/&+/, "&")
          url.gsub!(/\?&/, "?")

          url << (url =~ /\?/ ? "&" : "?")
          url << page.to_query(options[:param_name])
        end

        url.gsub!(/&/, "&amp;")
        url
      end
    end
  end
end
