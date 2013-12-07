require "dsjsrb"

describe DSJSRB do
  # each context has a global scope with variables
  let :js_context do
    DSJSRB::Context.new
  end

  describe "literal object expressions" do
    it "should parse object with one attribute" do
      obj = js_context.eval_expr('{a:1}')
      obj.get_attribute(:a).should be == 1.to_f
    end

    it "should parse object with one attribute" do
      obj = js_context.eval_expr('{b:1}')
      obj.get_attribute(:b).should be == 1.to_f
    end

    it "should parse object with one attribute" do
      obj = js_context.eval_expr('{a:2}')
      obj.get_attribute(:a).should be == 2.to_f
    end

    it "should parse object with one attribute" do
      obj = js_context.eval_expr('{b:2}')
      obj.get_attribute(:b).should be == 2.to_f
    end
  end
end
