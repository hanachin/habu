module Habu
  class Container
    attr_reader :factory

    def initialize
      @factory = {}
      @factory.define_singleton_method(:to_refinements) do
        factory_methods = singleton_methods.map(&self.:singleton_method)
        refinements = Module.new
        refinements.instance_exec(self) do |container|
          refine(Object) do
            factory_methods.each do |m|
              define_method(m.name, &m)
            end
          end
        end
        refinements
      end
    end

    def [](key, &block)
      if block
        @factory[key] = block
        container = self
        @factory.define_singleton_method(key) do
          block.call(container)
        end
      else
        @factory.fetch(key).call(self)
      end
    end

    def new(klass, &block)
      params = klass.instance_method(:initialize).parameters
      klass.new(*params.filter_map { @1 == :req && self[@2] }, &block)
    end

    def to_refinements
      refinements = Module.new
      refinements.instance_exec(self) do |container|
        Habu.annotation_collector.constructor_annotations.each do |klass_name|
          klass = const_get(klass_name)
          refine(klass.singleton_class) do
            define_method(:new) do |&block|
              container.new(klass, &block)
            end
          end
        end
      end
      refinements
    end
  end
end
