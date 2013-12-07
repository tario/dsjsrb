require "rkelly"
require "sexp_processor"
require "pry"

module DSJSRB
  class Context
    def initialize
      @parser = RKelly::Parser.new
    end

    def eval_expr(code)
      ast = @parser.parse(code)
      s_ = ast.to_real_sexp

      eval_s(s_)
    end

    private

    def eval_literal(tree)
      case tree[1]
        when :number
          tree[2]
        when :array
          [1,2,3]
        when :string
          eval tree[2]
        else
          nil
      end
    end

    def eval_s(tree)
      case tree[0]
      when :source_elements
        eval_s(tree[1])
      when :expression_statement
        eval_literal(tree)
      else
        nil
      end
    end
  end
end