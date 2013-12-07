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

    def self.variable_name_value(var_name, value)
      context "when variable name is '#{var_name}' and value is #{value}" do
        it "should allow read attributes as locals" do
          ctx = js_context
          ctx.global_scope.set_attribute(var_name.to_sym, 100)
          ctx.eval_expr(var_name).should be == 100.to_f
        end
      end
    end

    variable_name_value 'a', 100
    variable_name_value 'b', 100
    variable_name_value 'a', 200
    variable_name_value 'b', 200
  end
end
