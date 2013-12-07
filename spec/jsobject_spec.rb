require "dsjsrb"

describe DSJSRB do
  # each context has a global scope with variables
  let :js_context do
    DSJSRB::Context.new
  end

  describe "literal object expressions" do
    context "with one attribute" do
      it "should parse object" do
        js_context.tap do |ctx|
          ctx.eval_expr('obj = {a:1}')
          ctx.global_scope.get_attribute(:obj).get_attribute(:a).should be == 1.to_f
        end
      end

      it "should parse object" do
        js_context.tap do |ctx|
          ctx.eval_expr('obj = {b:1}')
          ctx.global_scope.get_attribute(:obj).get_attribute(:b).should be == 1.to_f
        end
      end

      it "should parse object" do
        js_context.tap do |ctx|
          ctx.eval_expr('obj = {a:2}')
          ctx.global_scope.get_attribute(:obj).get_attribute(:a).should be == 2.to_f
        end
      end

      it "should parse object" do
        js_context.tap do |ctx|
          ctx.eval_expr('obj = {b:2}')
          ctx.global_scope.get_attribute(:obj).get_attribute(:b).should be == 2.to_f
        end
      end
    end

    context "with two attributes" do
      it "should parse object" do
        ctx = js_context
        obj = ctx.eval_expr('obj = {a: 1, b: 2}')
        ctx.global_scope.get_attribute(:obj).get_attribute(:a).should be == 1.to_f
      end

      it "should parse object" do
        ctx = js_context
        obj = ctx.eval_expr('obj = {a: 1, b: 2}')
        ctx.global_scope.get_attribute(:obj).get_attribute(:b).should be == 2.to_f
      end
    end
  end
end
