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
          when :resolve
            s(:call, s(:lvar, :global_scope), :get_attribute, s(:lit, tree[2].to_sym))
          else
            raise "unrecognized expression type #{tree[1]}"
        end
      when :source_elements
        process(tree[-1])
      when :block
        s(:iter, 
          s(:call, 
            s(:call, s(:const, :JSObject), :new), :tap), 
              s(:args, :obj), 
              s(:call, s(:lvar, :obj), :set_attribute, s(:lit, tree[2][1]), process(tree[2][2])))
      else
        raise "unrecognize node type #{tree[0]}"
      end
    end
  end
end