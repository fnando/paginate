module Paginate
  module ActiveRecordExt
    def inherited(subclass)
      super(subclass)
      subclass.send(:include, Paginate::Extension) if subclass.superclass == ::ActiveRecord::Base
    end
  end
end

module ActiveRecord
  class Base
    class << self
      prepend Paginate::ActiveRecordExt
    end

    # Extend existing models
    self.descendants.each do |model|
      model.send(:include, Paginate::Extension) if model.superclass == ActiveRecord::Base
    end
  end
end
