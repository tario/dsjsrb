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
      s_ = ast.to_real_sexp
      ruby_tree = @processor.process(s_)
      current_scope = self.global_scope

      eval(Ruby2Ruby.new.process ruby_tree)
    end
  end
end