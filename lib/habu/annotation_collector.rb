require 'habu/annotation_collector_helper'

module Habu
  class AnnotationCollector
    using ::Habu::AnnotationCollectorHelper

    attr_reader :constructor_annotations

    def initialize
      @constructor_annotations = []
      @iseq_interceptor = new_iseq_interceptor
    end

    def install
      RubyVM::InstructionSequence.singleton_class.prepend(@iseq_interceptor)
    end

    private

    def add_constructor_annotation(klass)
      @constructor_annotations << klass
    end

    def new_iseq_interceptor
      add_constructor_annotation = self.:add_constructor_annotation
      Module.new do
        define_method :load_iseq do |fname|
          ast = RubyVM::AbstractSyntaxTree.parse_file(fname)
          ast.each_constructor_annotations(&add_constructor_annotation)
          RubyVM::InstructionSequence.compile_file(fname)
        end
      end
    end
  end
end
