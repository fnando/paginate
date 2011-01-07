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
    # * <tt>:size</tt>: the page size. When not specified will default to <tt>Paginate::Config.size</tt>.
    # * <tt>:param_name</tt>: the page param name. When not specified will default to <tt>Paginate::Config.param_name</tt>.
    #
    #   <%= paginate @posts, proc {|page| posts_path(page) }
    #   <%= paginate @posts, :url => proc {|page| posts_path(page) }
    #
    # You don't have to specify the URL; the current requested URI will be used if you don't provide it.
    #
    def paginate(collection, *args)
      options = args.extract_options!
      param_name = [options[:param_name], Paginate::Config.param_name, :page].compact.first
      options.merge!({
        :collection => collection,
        :page => params[param_name],
        :param_name => param_name,
        :fullpath => request.respond_to?(:fullpath) ? request.fullpath : request.request_uri
      })
      options.merge!(:url => args.first) if args.any?

      Paginate::Renderer.new(options).render
    end

    # In order to iterate the correct items you have to skip the last collection's item.
    # We added this helper to automatically skip the last item only if there's a next page.
    #
    #   <% iterate @items do |item| %>
    #   <% end %>
    #
    # If you want to grab the iteration index as well just expect it as a block parameter.
    #
    #   <% iterate @items do |item, i|
    #   <% end %>
    #
    # If you set a custom size while fetching items from database, you need to inform it while iterating.
    #
    #   @items = Item.paginate(:page => 1, :size => 5)
    #
    # Then in your view:
    #
    #   <% iterate @items, :size => 5 do |item| %>
    #   <% end %>
    #
    # You can receive the iteration counter by expecting two arguments.
    #
    #   <% iterate @items do |item, i| do %>
    #   <% end %>
    #
    def iterate(collection, options = {}, &block)
      options.reverse_merge!(:size => Paginate::Config.size)
      block_arity = block.arity

      collection[0, options[:size]].each_with_index do |item, i|
        if block_arity == 1
          yield item
        else
          yield item, i
        end
      end
    end
  end
end
