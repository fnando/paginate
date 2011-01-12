module ActiveRecord
  class Base
    scope :paginate, proc {|*args| Paginate::Base.new(*args).to_options }
  end
end
