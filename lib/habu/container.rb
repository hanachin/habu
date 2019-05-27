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

    def to_refinements
      @refinements = Module.new
      @refinements.instance_exec(self) do |container|
        Habu.annotation_collector.constructor_annotations.each do |klass_name|
          klass = const_get(klass_name)
          refine(klass.singleton_class) do
            define_method(:new) do |&block|
              container.new(klass, &block)
            end
          end
        end
      end
      @refinements
    end
  end
end
