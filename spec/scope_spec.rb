require "dsjsrb"

describe DSJSRB do
  # each context has a global scope with variables
  let :js_context do
    DSJSRB::Context.new
  end

  describe "context" do
    it "should have global scope" do
      js_context.should respond_to(:global_scope)
    end

    it "should accept attributes" do
      ctx = js_context
      ctx.global_scope.set_attribute(:a, 100)
      ctx.global_scope.get_attribute(:a).should be == 100
    end

    it "should allow read attributes as locals" do
      ctx = js_context
      ctx.global_scope.set_attribute(:a, 100)
      ctx.eval_expr('a').should be == 100.to_f
    end
  end
end
