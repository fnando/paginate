# Paginate

[![Build Status](https://travis-ci.org/fnando/paginate.png)](https://travis-ci.org/fnando/paginate)
[![CodeClimate](https://codeclimate.com/github/fnando/paginate.png)](https://codeclimate.com/github/fnando/paginate/)
[![Test Coverage](https://codeclimate.com/github/fnando/paginate/badges/coverage.svg)](https://codeclimate.com/github/fnando/paginate/coverage)
[![Gem](https://img.shields.io/gem/v/paginate.svg)](https://rubygems.org/gems/paginate)
[![Gem](https://img.shields.io/gem/dt/paginate.svg)](https://rubygems.org/gems/paginate)

Paginate collections using SIZE+1 to determine if there is a next page. Includes ActiveRecord and ActionView support.

## Install

```bash
gem install paginate
```

## Usage

You can use Paginate with or without ActiveRecord. Let's try a simple array pagination. Imagine that you have something like this in your controller.

```ruby
@things = Array.new(11) {|i| "Item #{i}"}
```

Then on your view:

```erb
<%= paginate @things %>
```

That's it! This is all you have to do! In this case we're using the default page size (which is 10).
The url used on page links is taken from the current requested uri.

You can set default values globally:

```ruby
Paginate.configure do |config|
  config.size = 20
  config.param_name = :p
end
```

More examples:

```ruby
Post.paginate(1)                                # page 1 from Post model
Post.paginate(page: 1)                          # page 1 from Post model
Post.paginate(page: 1, size: 5)                 # page 1 from Post model with custom size
@user.things.paginate(:page => params[:page])   # paginate association
```

```erb
<%= paginate @things, size: 5 %>
<%= paginate @things, url: -> page { things_path(:page => page) } %>
<%= paginate @things, "/some/path" %>
<%= paginate @things, param_name: :p %>
```

To render the collection, you must use the <tt>render</tt> helper, providing the <tt>:paginate => true</tt> option. This is required cause we're always considering SIZE + 1, so if you use the regular +each+ or don't pass this option, you end up rendering one additional item.

```erb
<%= render @things, paginate: true %>
<%= render @things, paginate: true, size: 5 %>
<%= render "thing", collection: @things, paginate: true, size: 5 %>
```

## I18n support

If you want to translate links, you have implement the following scopes:

```yaml
en:
  paginate:
    next: "Older"
    previous: "Newer"
    page: "Page %{page}"
    more: "Load more"
```

## Styling

If you want something like Twitter Search use this CSS:

```css
.paginate { overflow: hidden; }
.paginate li { float: left; }
.paginate li.previous-page:after { content: "«"; padding: 0 5px; }
.paginate li.next-page:before { content: "»"; padding: 0 5px; }
.paginate .disabled { display: none; }
```

You can create new renderers. Paginate comes with two renderers.

* `Paginate::Renderer::List`: is the default renderer. Uses a `<ul>` with previous and next page. Also displays the current page.
* `Paginate::Renderer::More`: define a "Load more" page. This is useful for renderer pagination through AJAX.

To create a new renderer, just inherit from `Paginate::Renderer::Base` and define the `render` method. Here's the `Paginate::Renderer::More` code:

```ruby
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
```

You can specify the default renderer by setting the `Pagination.configuration.renderer` option.

```ruby
Paginate.configure do |config|
  config.renderer = Paginate::Renderer::More
end
```

You can also specify while calling the `paginate` helper.

```erb
<%= paginate @items, renderer: Paginate::Renderer::More %>
```

## License

(The MIT License)

Copyright - Nando Vieira • <http://nandovieira.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
