module Paginate
  module Renderer
    class More < Base
      def more_label
        I18n.t("paginate.more")
      end

      def render
        return unless processor.next_page?

        <<-HTML.html_safe
          <p class="paginate">
            <a class="more" href="#{next_url}" title="#{more_label}">#{more_label}</a>
          </p>
        HTML
      end
    end
  end
end
