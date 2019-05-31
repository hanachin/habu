module Habu
  class Container
    attr_reader :factory

    def initialize(
          annotation_collector: Habu.annotation_collector,
          factory: Factory.new(self)
        )
      @annotation_collector = annotation_collector
      @factory = factory
    end

    def [](key, &block)
      if block
        @factory.register(key, &block)
      else
        @factory.resolve(key)
      end
    end

    def new(klass, &block)
      params = klass.instance_method(:initialize).parameters
      klass.new(*params.filter_map { @1 == :req && self[@2] }, &block)
    end

    def to_refinements
      refinements = Module.new
      refinements.instance_exec(@annotation_collector, self) do |annotation_collector, container|
        annotation_collector.constructor_annotations.each do |klass_name|
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
