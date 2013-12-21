module DSJSRB
  class JSFunction
    class JSFunctionCall
      attr_reader :current_scope
      def initialize(current_scope, &blk)
        @blk = blk
        @current_scope = current_scope
      end

      def call(*args)
        instance_exec(*args, &@blk)
      end
    end

    def initialize(parent_scope = JSObject.new, &blk)
      @blk = blk
      @parent_scope = parent_scope
    end

    def call(*args)
      JSFunctionCall.new(JSObject.create(@parent_scope), &@blk).call(*args)
    end
  end
end
