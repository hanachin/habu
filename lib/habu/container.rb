module Habu
  class Container
    def initialize
      @factories = {}
    end

    def [](key, &block)
      if block
        @factories[key] = block
      else
        @factories.fetch(key).call(self)
      end
    end
  end
end
