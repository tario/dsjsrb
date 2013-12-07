# converts JS sexp trees to ruby sexp trees
module DSJSRB
  class Processor
    def process(tree)
      case tree[0]
      when :element, :expression_statement
        case tree[1]
          when :number
            s(:lit, tree[2])
          when :array
            s(:array).tap do |s|
              tree[2..-1].map(&method(:process)).each(&s.method(:<<))
            end
          when :string
            s(:str, eval(tree[2]))
        end
      when :source_elements
        process(tree[-1])
      else
        raise "unrecognize node type #{tree[0]}"
      end
    end
  end
end