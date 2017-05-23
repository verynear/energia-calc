module Dentaku
  module AST
    class Node
      def dependencies(_context = {})
        []
      end
    end

    class Negation
      def dependencies(_context = {})
        []
      end
    end
  end

  class BulkExpressionSolver
    def load_results(&block)
      variables_in_resolve_order.each_with_object({}) do |var_name, r|
        begin
          proposed = calculator.memory[var_name]
          if proposed.is_a?(Numeric)
            r[var_name] = proposed
          else
            r[var_name] = evaluate!(expressions[var_name], expressions.merge(r))
          end
        rescue Dentaku::UnboundVariableError, ZeroDivisionError, ArgumentError => ex
          r[var_name] = block.call(ex, var_name)
        end
      end
    end
  end
end
