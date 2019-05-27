module Habu
  module Setup
    class << self
      def install(annotation_collector)
        ::Habu.annotation_collector = annotation_collector
        ::Habu.annotation_collector.install
      end
    end
  end
end

Habu::Setup.install(::Habu::AnnotationCollector.new)
