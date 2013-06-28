module Paginate
  module Renderer
    class List < Base
      def previous_label
        I18n.t("paginate.previous")
      end

      def next_label
        I18n.t("paginate.next")
      end

      def page_label
        I18n.t("paginate.page", page: processor.page)
      end

      def render
        html = String.new

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
end
