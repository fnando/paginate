# This renderer will make the follow code, on paginate helper method, when...
# 
# a) Have only one page:
#
#   <ul class="paginate disabled">
#     <li class="previous-page disabled"><span title="Previous">Previous</span></li>
#     <li class="page"><span>Page 1</span></li>
#     <li class="next-page disabled"><span title="Next page">Next page</span></li>
#   </ul>
#
# b) Have only next page:
#   <ul class="paginate">
#     <li class="previous-page disabled"><span title="Previous">Previous</span></li>
#     <li class="page"><span>Page 1</span></li>
#     <li class="next-page"><a href="/current-resource?page=2" title="Next page">Next page</a></li>
#   </ul>
#
# c) Have previous and next page:
#   <ul class="paginate">
#     <li class="previous-page"><a href="/current-resource?page=1" title="Previous">Previous</a></li>
#     <li class="page"><span>Page 2</span></li>
#     <li class="next-page"><a href="/current-resource?page=3" title="Next page">Next page</a></li>
#   </ul>
#
# c) Have only previous page:
#   <ul class="paginate">
#     <li class="previous-page"><a href="/current-resource?page=1" title="Previous">Previous</span></li>
#     <li class="page"><span>Page 2</span></li>
#     <li class="next-page disabled"><span title="Next page">Next page</span></li>
#   </ul>
# 
# If you want to translate links, you have implement the following scopes:
# 
#   en:
#     paginate:
#       next: "Older"
#       previous: "Newer"
#       page: "Page %{page}"
#   pt:
#     paginate:
#       next: "Pr&oacute;xima"
#       previous: "Anterior"
#       page: "P&aacute;gina %{page}"
module Paginate
  module Renderer
    class Basic < Base
      def render
        previous_label = I18n.t("previous", :scope => "paginate")
        next_label     = I18n.t("next", :scope => "paginate")
        page_label     = I18n.t("page", options.merge(:scope => "paginate"))

        page           = options[:page].to_i
        previous_url   = current_url_for(page - 1)
        next_url       = current_url_for(page + 1)

        css = %w[ paginate ]
        css << "disabled" unless processor.previous_page? || processor.next_page?

        html = String.new
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
