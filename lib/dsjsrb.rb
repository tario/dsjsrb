require "rkelly"
require "sexp_processor"
require "pry"
require "dsjsrb/processor"
require "ruby2ruby"

module DSJSRB
  class Context
    def initialize
      @parser = RKelly::Parser.new
      @processor = DSJSRB::Processor.new
    end

    def eval_expr(code)
      ast = @parser.parse(code)
      s_ = ast.to_real_sexp
      ruby_tree = @processor.process(s_)

      eval(Ruby2Ruby.new.process ruby_tree)
    end
  end
end