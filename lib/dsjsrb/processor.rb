# converts JS sexp trees to ruby sexp trees
module DSJSRB
  class Processor

    def process_expression(tree)
      case tree[0]
        when :number
          s(:lit, tree[1])
        when :array
          s(:array).tap do |s|
            tree[1..-1].map(&method(:process_expression)).each(&s.method(:<<))
          end
        when :string
          s(:str, eval(tree[1]))
        when :resolve
          s(:call, s(:call, s(:self), :current_scope), :get_attribute, s(:lit, tree[1].to_sym))
        when :op_equal
          case tree[1][0]
          when :resolve
            s(:call, s(:call, s(:self), :current_scope), :set_attribute_no_local, s(:lit, tree[1][1].to_sym), process_expression(tree[2]))
          when :dot_accessor
            s(:call,
              process_expression(tree[1][1..-2]),
              :set_attribute,
              s(:lit, tree[1][-1].to_sym),
              process_expression(tree[2])
              )
          else
            raise "unrecognized accessor type #{tree[1][0]}"
          end
        when :object_literal
          assignation_block = s(:block)
          tree[1..-1].each do |subtree|
            assignation_block << s(:call, s(:lvar, :obj), :set_attribute, s(:lit, subtree[1]), process_expression(subtree[2]))
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
            process_expression(tree[1..-2]),
            :get_attribute,
            s(:lit, tree[-1].to_sym)
            )
        when :function_expr
          arguments = s(:args)
          f_body = s(:block)

          tree[2].each do |argument|
            arguments << argument.last.to_sym
            f_body << s(:call, 
                          s(:call, s(:self), :current_scope), 
                          :define_attribute, 
                          s(:lit, arguments.last), 
                          s(:call, nil, arguments.last))
          end

          f_body << process(tree[-1])

          s(:iter, s(:call, s(:const, :JSFunction), :new, s(:call, s(:self), :current_scope)), arguments, f_body)
        when :assign_expr
          process_expression(tree[1..-1])
        when :element
          process_expression(tree[1..-1])
        else
          raise "unrecognized expression type #{tree[0]}"
      end
    end

    def process(tree)
      case tree[0]
      when :expression_statement
          process_expression(tree[1..-1])
      when :source_elements
        process(tree[-1])
      when :number
        s(:lit, tree[1])
      when :var_decl
        s(:call, s(:call, s(:self), :current_scope), :define_attribute, s(:lit, tree[1].to_sym), process_expression(tree[-1]))
      when :var_statement
        process(tree[-1])
      when :return
        s(:next, process_expression(s(*tree[1..-1])))
      when :function_body
        subtree = tree[2]
        if subtree
          s(:block).tap do |ret|
            tree[2..-1].map(&method(:process)).each(&ret.method(:<<))
          end
        else
          s(:next, s(:nil))
        end
      else
        raise "unrecognize node type #{tree[0]}"
      end
    end
  end
end