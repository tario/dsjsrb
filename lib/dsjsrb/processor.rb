# converts JS sexp trees to ruby sexp trees
module DSJSRB
  class Processor

    def process_expresion(tree)
      case tree[0]
        when :number
          s(:lit, tree[1])
        when :array
          s(:array).tap do |s|
            tree[1..-1].map(&method(:process_expresion)).each(&s.method(:<<))
          end
        when :string
          s(:str, eval(tree[1]))
        when :resolve
          s(:call, s(:lvar, :current_scope), :get_attribute, s(:lit, tree[1].to_sym))
        when :op_equal
          case tree[1][0]
          when :resolve
            s(:call, s(:call, nil, :current_scope), :set_attribute, s(:lit, tree[1][1].to_sym), process_expresion(tree[2]))
          when :dot_accessor
            s(:call,
              process_expresion(tree[1][1..-2]),
              :set_attribute,
              s(:lit, tree[1][-1].to_sym),
              process_expresion(tree[2])
              )
          else
            raise "unrecognized accessor type #{tree[1][0]}"
          end
        when :object_literal
          assignation_block = s(:block)
          tree[1..-1].each do |subtree|
            assignation_block << s(:call, s(:lvar, :obj), :set_attribute, s(:lit, subtree[1]), process_expresion(subtree[2]))
          end

          s(:iter, 
            s(:call, 
              s(:call, s(:const, :JSObject), :new), :tap), 
                s(:args, :obj),
                assignation_block)
        when :null
          s(:nil)
        when :dot_accessor
          s(:call,
            process_expresion(tree[1..-2]),
            :get_attribute,
            s(:lit, tree[-1].to_sym)
            )
        when :function_expr
          s(:iter, s(:call, nil, :lambda), s(:args), process(tree[-1]))
        when :element
          process_expresion(tree[1..-1])
        else
          raise "unrecognized expression type #{tree[0]}"
      end
    end

    def process(tree)
      case tree[0]
      when :expression_statement
          process_expresion(tree[1..-1])
      when :source_elements
        process(tree[-1])
      when :number
        s(:lit, tree[1])
      when :return
        s(:next, process_expresion(s(*tree[1..-1])))
      when :function_body
        subtree = tree[2]
        subtree ? process(subtree) : s(:nil)
      else
        raise "unrecognize node type #{tree[0]}"
      end
    end
  end
end