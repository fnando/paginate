class ActiveRecord::Base
  class << self
    alias_method :original_inherited, :inherited
  end

  def self.inherited(child)
    original_inherited(child)

    child.class_eval do
      if Rails.version >= "3.0"
        scope :paginate, proc {|*args| Paginate::Base.new(*args).to_options }
      else
        named_scope :paginate, proc {|*args| Paginate::Base.new(*args).to_options }
      end
    end
  end
end
