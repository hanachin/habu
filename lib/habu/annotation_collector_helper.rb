module Habu
  module AnnotationCollectorHelper
    refine(Object) do
      def traversable?
        false
      end
    end

    refine(RubyVM::AbstractSyntaxTree::Node) do
      def traversable?
        true
      end

      def traverse(&block)
        block.call(self)
        children.each { |child| child.traverse(&block) if child.traversable? }
      end

      def deconstruct
        [type, *children]
      end

      def each_constructor_annotations(&block)
        klass_name = nil
        inject_annotation_found = false
        traverse do |ast|
          case ast
          in :CLASS, [:COLON2, nil, klass_name], *_
            # TODO: Support namespace
          in :IVAR, :@Inject
            inject_annotation_found = true
          in :DEFN, :initialize, *_ if inject_annotation_found == true
            block.call(klass_name)
            inject_annotation_found = false
          else
            inject_annotation_found = false
          end
        end
      end
    end
  end
end
