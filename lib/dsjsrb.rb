module DSJSRB
  class Context
    def eval_expr(code)
      if code.start_with?("'") or code.start_with?('"')
        eval code
      else
        code.to_f
      end
    end
  end
end