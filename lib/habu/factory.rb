module Habu
  class Factory
    def initialize(container)
      @container = container
      @registered_service_hash = {}
    end

    def register(service, &block)
      @registered_service_hash[service] = block
      define_singleton_method(service) do
        block.call(@container)
      end
    end

    def resolve(service)
      @registered_service_hash.fetch(service).call(@container)
    end

    def to_refinements
      factory_methods = singleton_methods.map(&self.:singleton_method)
      refinements = Module.new
      refinements.instance_exec do |container|
        refine(Object) do
          factory_methods.each do |m|
            define_method(m.name, &m)
          end
        end
      end
      refinements
    end
  end
end
