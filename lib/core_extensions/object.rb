module CoreExtensions
  module Object

    def is_in?(a)
      a.kind_of?(Enumerable) && a.include?(self)
    end

    def not_in?(a)
      a.kind_of?(Enumerable) && !a.include?(self)
    end

  end
end

Object.send(:include, CoreExtensions::Object)
