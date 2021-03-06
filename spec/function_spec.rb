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
    it "should return #{value}" do
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

  describe "function returning 0" do
    subject do
      js_context.eval_expr("f = function(){return 0; }")
      js_context.global_scope.get_attribute(:f)
    end

    it_behaves_like "a callable object returning", 0.to_f
  end

  describe "function returning object" do
    subject do
      js_context.eval_expr("f = function(){return {a: 1, b: 2}; }")
      js_context.global_scope.get_attribute(:f)
    end

    it_behaves_like "a callable object"
    it "should return obj.a == 1" do
      subject.call.get_attribute(:a).should be == 1
    end

    it "should return obj.b == 2" do
      subject.call.get_attribute(:b).should be == 2
    end
  end

  describe "function receiving arguments" do
    subject do
      js_context.eval_expr("f = function(x){return x; }")
      js_context.global_scope.get_attribute(:f)
    end

    it_behaves_like "a callable object"
    ["test", 0.0, nil].each do |value|
      context "when called with #{value.inspect}" do
        it "should return #{value.inspect}" do
          subject.call(value).should be == value 
        end
      end
    end
  end

  describe "function returning variables of parent scope" do
    subject do
      js_context.eval_expr("f = function(){return y; }")
      js_context.global_scope.get_attribute(:f)
    end

    it_behaves_like "a callable object"

    ["test", 0.0, nil].each do |value|
      context "when set value of y = #{value.inspect}" do
        before do
          js_context.global_scope.set_attribute(:y, value)
        end

        it "should return #{value.inspect}" do
          subject.call(value).should be == value 
        end
      end
    end
  end

  describe "function assigning variables with same name of parent scope" do
    subject do
      js_context.eval_expr("f = function(){y = 4; }")
      js_context.global_scope.get_attribute(:f)
    end

    it_behaves_like "a callable object"
    context "when called" do
      it "should assign y = 4" do
        subject.call 
        js_context.global_scope.get_attribute(:y).should be == 4
      end
    end
  end

  describe "function defining variables with same name of parent scope" do
    subject do
      js_context.eval_expr("f = function(){var y = 4; return y; }")
      js_context.global_scope.get_attribute(:f)
    end

    it_behaves_like "a callable object"
    context "when called after setting y to nil" do
      it "y on global scope should remain unmodified" do
        js_context.global_scope.set_attribute(:y, nil)
        subject.call
        js_context.global_scope.get_attribute(:y).should be == nil
      end

      it "should return 4" do
        js_context.global_scope.set_attribute(:y, nil)
        subject.call.should be == 4.0
      end
    end
  end

  describe "function defining variables with complex expressions" do
    subject do
      js_context.eval_expr("f = function(){var y = function(){return 4; }; return y; }")
      js_context.global_scope.get_attribute(:f)
    end

    it_behaves_like "a callable object"
    it "should return a callable" do
      subject.call.should respond_to(:call)
    end

    it "should return a callable, a function returning 4" do
      subject.call.call.should be == 4.0
    end
  end
end

