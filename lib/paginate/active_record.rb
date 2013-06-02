module ActiveRecord
  class Base
    class << self
      def inherited_with_paginate(subclass)
        inherited_without_paginate subclass
        subclass.send(:include, Paginate::Extension) if subclass.superclass == ActiveRecord::Base
      end

      alias_method_chain :inherited, :paginate
    end

    # Extend existing models
    self.descendants.each do |model|
      model.send(:include, Paginate::Extension) if model.superclass == ActiveRecord::Base
    end
  end
end
