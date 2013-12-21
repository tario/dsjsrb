require "dsjsrb"

describe DSJSRB::JSFunction do
  let :js_context do
    DSJSRB::Context.new
  end
  
  shared_examples_for "a callable object" do
    it "should respond to call" do
      should respond_to(:call)
    end
  end

  shared_examples_for "a callable object returning" do |value|
    it_behaves_like "a callable object"
    it "should return" do
      subject.call.should be == value
    end
  end

  describe "empty function" do
    subject do
      js_context.eval_expr("f = function(){}")
      js_context.global_scope.get_attribute(:f)
    end

    it_behaves_like "a callable object"
  end

  describe "function returning null" do
    subject do
      js_context.eval_expr("f = function(){return null; }")
      js_context.global_scope.get_attribute(:f)
    end

    it_behaves_like "a callable object returning", nil
  end
end

