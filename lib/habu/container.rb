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

    def new(klass, &block)
      params = klass.instance_method(:initialize).parameters
      klass.new(*params.filter_map { @1 == :req && self[@2] }, &block)
    end
  end
end
