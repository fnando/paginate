module Paginate
  class Renderer
    attr_accessor :options
    attr_accessor :current_page

    def initialize(options)
      @current_page = [options[:page].to_i, 1].max
      options.reverse_merge!(Paginate::Config.to_hash)
      @options = options.merge(:page => current_page)
    end

    def processor
      @processor ||= Paginate::Base.new(options)
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

    def render
      html = String.new
      previous_label = I18n.t("paginate.previous")
      previous_url = url_for(options[:page] - 1)
      next_label = I18n.t("paginate.next")
      next_url = url_for(options[:page] + 1)
      page_label = I18n.t("paginate.page", options)

      css = %w[ paginate ]
      css << "disabled" unless processor.previous_page? || processor.next_page?

      html << %[<ul class="#{css.join(" ")}">]

      # Previous page
      if processor.previous_page?
        html << %[<li class="previous-page"><a href="#{previous_url}" title="#{previous_label}">#{previous_label}</a></li>]
      else
        html << %[<li class="previous-page disabled"><span title="#{previous_label}">#{previous_label}</span></li>]
      end

      # Current page
      html << %[<li class="page"><span>#{page_label}</span></li>]

      # Next page
      if processor.next_page?
        html << %[<li class="next-page"><a href="#{next_url}" title="#{next_label}">#{next_label}</a></li>]
      else
        html << %[<li class="next-page disabled"><span title="#{next_label}">#{next_label}</span></li>]
      end

      html << %[</ul>]

      html.html_safe
    end
  end
end
