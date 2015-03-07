module Paginate
  module Renderer
    class Base
      # Set the pagination options.
      attr_reader :options

      # Set the view context. You can use this object
      # to call view and url helpers.
      attr_reader :view_context

      # Set the object with defines all pagination methods
      # like `Paginate::Base#next_page?`.
      attr_reader :processor

      def initialize(view_context, options)
        @view_context = view_context
        @options = options.reverse_merge(Paginate.configuration.to_hash)
        @processor = Paginate::Base.new(nil, options)
      end

      # Return the URL for previous page.
      def previous_url
        url_for(processor.page - 1)
      end

      # Return the URL for next page.
      def next_url
        url_for(processor.page + 1)
      end

      # Compute the URL for a given page.
      # It will keep track of all query string and replace the
      # page parameter with the specified `page`.
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
