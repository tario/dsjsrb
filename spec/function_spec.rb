require "dsjsrb"

describe DSJSRB::JSFunction do
  let :js_context do
    DSJSRB::Context.new
  end

  describe "empty function" do
    subject do
      js_context.eval_expr("f = function(){}")
    end

    it "should respond to call" do
      should respond_to(:call)
    end
  end
end

