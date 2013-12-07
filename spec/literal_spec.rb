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

  describe "number evaluation" do
    (1..5).each do |number|
      expr_should_evaluate(number.to_s,number.to_f)
    end
  end 

  describe "string evaluation" do
    ['foo', 'bar'].each do |str|
      expr_should_evaluate("\"#{str}\"",str)
      expr_should_evaluate("\'#{str}\'",str)
    end
  end

  describe "array evaluation" do
    expr_should_evaluate("[1,2,3]",[1,2,3])
    expr_should_evaluate("[4,5,6]",[4,5,6])
  end
end
