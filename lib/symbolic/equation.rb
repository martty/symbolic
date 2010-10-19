module Symbolic
	class Equation
		include Symbolic
		
		class << self
		end
		attr_accessor :rhs, :lhs
		def initialize(rhs, lhs)
  	  @rhs, @lhs = rhs, lhs
    end
        
    def +(var)
    	Equation.new @rhs + var, @lhs + var
    end
    
    def -(var)
    	Equation.new @rhs - var, @lhs - var
    end
    
    def *(var)
    	Equation.new @rhs * var, @lhs * var
    end
    
    def /(var)
    	Equation.new @rhs / var, @lhs / var
    end
    
    def **(var)
    	Equation.new @rhs ** var, @lhs ** var
    end
    
    def to_zero
    	Equation.new @rhs - @lhs, 0
    end
    
    def ==(other)
    	if(other.is_a?(Equation))
    		z = to_zero
    		otherz = other.to_zero
    		return z.rhs == otherz.rhs
    	end
    	false
    end
	end
end
