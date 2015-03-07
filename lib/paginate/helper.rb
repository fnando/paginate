module Paginate
  module Helper
    # Display pagination based on the collection and current page.
    #
    #   <%= paginate @posts %>
    #   <%= paginate @posts, options %>
    #   <%= paginate @posts, posts_path, options %>
    #
    # The available options are:
    #
    # * <tt>:url</tt>: the URL which page numbers will be appended to. Can be proc or string.
    # * <tt>:id</tt>: the HTML id that will identify the pagination block.
    # * <tt>:size</tt>: the page size. When not specified will default to <tt>Paginate.configuration.size</tt>.
    # * <tt>:param_name</tt>: the page param name. When not specified will default to <tt>Paginate.configuration.param_name</tt>.
    # * <tt>:renderer</tt>: A class that will be used to render the pagination. When not specified will default to <tt>Paginate::Renderer::List</tt>.
    #
    #   <%= paginate @posts, proc {|page| posts_path(page) }
    #   <%= paginate @posts, :url => proc {|page| posts_path(page) }
    #
    # You don't have to specify the URL; the current requested URI will be used if you don't provide it.
    #
    def paginate(collection, *args)
      options = args.extract_options!

      param_name = [
        options[:param_name],
        Paginate.configuration.param_name,
        :page
      ].compact.first

      renderer = [
        options[:renderer],
        Paginate.configuration.renderer,
        Paginate::Renderer::List
      ].compact.first

      options.merge!({
        collection: collection,
        page: params[param_name],
        param_name: param_name,
        fullpath: request.fullpath
      })

      options.merge!(url: args.first) if args.any?
      renderer.new(self, options).render
    end

    # Override the original render method, so we can strip the additional
    # item from the collection, without changing your workflow with the
    # iterate "always felt dirty" method.
    #
    # To render a paginated set, just pass the <tt>:paginate => true</tt> option.
    # You can also provide a custom size with <tt>:size => number</tt>
    #
    #   <%= render @posts, :paginate => true %>
    #   <%= render @pots, :paginate => true, :size => 20 %>
    #   <%= render "post", :collection => @posts, :paginate => true, :size => 20 %>
    #
    def render(*args, &block)
      options    = args.extract_options!
      paginated  = options.delete(:paginate)
      size       = options.delete(:size) { Paginate.configuration.size }

      return super(*[*args, options], &block) unless paginated
      collection = options.delete(:collection) { args.shift }
      collection = collection[0, size]

      super(collection, *[*args, options], &block)
    end
  end
end
