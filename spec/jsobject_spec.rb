require "dsjsrb"

describe DSJSRB::JSObject do
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

  describe "object getters" do
    it "should read attribute" do
      ctx = js_context
      ctx.global_scope.set_attribute(:obj, DSJSRB::JSObject.new.tap do |obj|
        obj.set_attribute(:a,300)
      end)

      ctx.eval_expr('obj.a').should be == 300
    end

    context "when multiple dots" do
      it "should read attribute" do
        ctx = js_context
        a = DSJSRB::JSObject.new
        obj = DSJSRB::JSObject.new
        obj.set_attribute(:a, a)
        a.set_attribute(:x,4)

        ctx.global_scope.set_attribute(:obj, obj)
        ctx.eval_expr('obj.a.x').should be == 4
      end
    end
  end

  describe "object setters" do
    it "should write attribute" do
      ctx = js_context
      ctx.global_scope.set_attribute(:obj, DSJSRB::JSObject.new)
      ctx.eval_expr('obj.a = 300')
      ctx.global_scope.get_attribute(:obj).get_attribute(:a).should be == 300.to_f
    end
  end

  describe "#create" do
    context "when object is created from another" do
      it "should inherit properties" do
        obj = DSJSRB::JSObject.new
        obj2 = DSJSRB::JSObject.create(obj)

        obj.define_attribute(:a, 100)
        obj2.get_attribute(:a).should be == 100
      end

      it "should NOT overwrite properties" do
        obj = DSJSRB::JSObject.new
        obj2 = DSJSRB::JSObject.create(obj)

        obj.define_attribute(:a, 100)
        obj2.define_attribute(:a, 200)
        obj.get_attribute(:a).should be == 100
      end

      it "should allow write own properties" do
        obj = DSJSRB::JSObject.new
        obj2 = DSJSRB::JSObject.create(obj)

        obj.define_attribute(:a, 100)
        obj2.define_attribute(:a, 200)
        obj2.get_attribute(:a).should be == 200
      end

      it "should allow remove properties" do
        obj = DSJSRB::JSObject.new
        obj2 = DSJSRB::JSObject.create(obj)

        obj.define_attribute(:a, 100)
        obj2.define_attribute(:a, 200)
        obj2.remove_attribute(:a)
        obj2.get_attribute(:a).should be == 100
      end
    end
  end

end
