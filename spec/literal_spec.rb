require "dsjsrb"

describe DSJSRB do
  let :js_context do
    DSJSRB::Context.new
  end

  def self.expr_should_evaluate(expr, result)
    it "expression #{expr} should evaluate to #{result}" do
      js_context.eval_expr(expr).should be == result
    end
  end

  (1..5).each do |number|
    expr_should_evaluate(number.to_s,number.to_f)
  end
end
