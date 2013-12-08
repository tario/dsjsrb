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
            s(:call, s(:lvar, :current_scope), :get_attribute, s(:lit, tree[2].to_sym))
          when :op_equal
            case tree[2][0]
            when :resolve
              s(:call, s(:call, nil, :current_scope), :set_attribute, s(:lit, tree[2][1].to_sym), process(tree[3]))
            when :dot_accessor
              s(:call,
                s(:call, s(:lvar, :current_scope), :get_attribute, s(:lit, tree[2][2].to_sym)),
                :set_attribute,
                s(:lit, tree[2][3].to_sym),
                process(tree[3])
                )
            else
              raise "unrecognized accessor type #{tree[2][0]}"
            end
          when :dot_accessor
            s(:call,
              s(:call, s(:lvar, :current_scope), :get_attribute, s(:lit, tree[3].to_sym)),
              :get_attribute,
              s(:lit, tree[4].to_sym)
              )
          else
            raise "unrecognized expression type #{tree[1]}"
        end
      when :source_elements
        process(tree[-1])
      when :number
        s(:lit, tree[1])
      when :object_literal
        assignation_block = s(:block)
        tree[1..-1].each do |subtree|
          assignation_block << s(:call, s(:lvar, :obj), :set_attribute, s(:lit, subtree[1]), process(subtree[2]))
        end

        s(:iter, 
          s(:call, 
            s(:call, s(:const, :JSObject), :new), :tap), 
              s(:args, :obj),
              assignation_block)
      else
        raise "unrecognize node type #{tree[0]}"
      end
    end
  end
end