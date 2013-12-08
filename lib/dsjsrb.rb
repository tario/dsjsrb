require "rkelly"
require "sexp_processor"
require "pry"
require "ruby2ruby"
require "dsjsrb/processor"
require "dsjsrb/jsobject"

module DSJSRB
  class Context
    attr_reader :global_scope

    def initialize
      @parser = RKelly::Parser.new
      @processor = DSJSRB::Processor.new
      @global_scope = DSJSRB::JSObject.new
    end

    def eval_expr(code)
      ast = @parser.parse(code)
      s_ = my_to_real_sexp(ast)
      ruby_tree = @processor.process(s_)
      current_scope = self.global_scope

      eval(Ruby2Ruby.new.process ruby_tree)
    end

private

    class MyRealSexpVisitor < RKelly::Visitors::Visitor
      ALL_NODES.each do |type|
        eval <<-RUBY
          def visit_#{type}Node(o)
            sexp = s(:#{type.scan(/[A-Z][a-z]+/).join('_').downcase}, *super(o))
            sexp.line = o.line if o.line
            sexp.file = o.filename
            sexp
          end
        RUBY
      end

      def visit_DotAccessorNode(o)
        sexp = s(:dot_accessor, *super(o), o.accessor)
        sexp.line = o.line if o.line
        sexp.file = o.filename
        sexp
      end
    end

    def my_to_real_sexp(ast)
      MyRealSexpVisitor.new.accept(ast)
    end
  end
end