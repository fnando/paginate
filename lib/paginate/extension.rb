module Paginate
  module Extension
    extend ActiveSupport::Concern

    included do
      scope :paginate, proc {|*args|
        Paginate::Base.new(
          ActiveRecord::VERSION::MAJOR < 4 ? scoped : all,
          *args
        ).to_scope
      }
    end
  end
end
