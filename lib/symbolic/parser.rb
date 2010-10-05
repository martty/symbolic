module Symbolic
	# Shunting Yard Algorithm implementation from:
	#http://rubyforge.org/projects/shunt/ 

	Oper = Struct.new(:pri,:sym,:type)
	
	class RPNOutput
		def initialize; @rpn = []; end
		def oper o;     @rpn << o.sym; end
		def value v;    @rpn << v; end
		def result;     @rpn; end
	end

	class ShuntingYard
		def initialize opers,output
		  @ostack,@opers,@out = [],opers,output
		end

		def reduce op = nil
		  pri = op ? op.pri : 0
		  # We check for :postfix to handle cases where a postfix operator has been given a lower precedence than an
		  # infix operator, yet it needs to bind tighter to tokens preceeding it than a following infix operator regardless,
		  # because the alternative gives a malfored expression.
		  while  !@ostack.empty? && (@ostack[-1].pri >= pri || @ostack[-1].type == :postfix)
		    o = @ostack.pop
		    if op and o.type == :lp # not rp, do not eat the lp
		    	@ostack.push(o)
		    end
		    return if o.type == :lp
		    @out.oper(o)
		  end
		end

		def shunt src
		  possible_func = false     # was the last token a possible function name?
		  opstate = :prefix         # IF we get a single arity operator right now, it is a prefix operator
		                            # "opstate" is used to handle things like pre-increment and post-increment that
		                            # share the same token.
		  src.each do |token|
		  	#p token
		  	#p @ostack
		  	#p @out.result
		    if op = @opers[token]
		      op = op[opstate] if op.is_a?(Hash)
		      if op.type == :rp then reduce
		      else
		        opstate = :prefix
		        reduce op # For handling the postfix operators
		        @ostack << (op.type == :lp && possible_func ? Oper.new(1, :call, :infix) : op)
		      end
		    else 
		      @out.value(token)
		      opstate = :infix_or_postfix # After a non-operator value, any single arity operator would be either postfix,
		                                  # so when seeing the next operator we will assume it is either infix or postfix.
		    end
		    possible_func = !op && !token.is_a?(Numeric)
		  end
		  reduce
		  
		  return @out if  @ostack.empty?
		  raise "Syntax error. #{@ostack.inspect}"
		end
	end

	def self.shunt a
		opers = {
		  "+" => Oper.new(10, :plus,  :infix),
		  "++" => {:infix_or_postfix => Oper.new(30, :postincr,  :postfix), 
		           :prefix => Oper.new(30,:preincr, :prefix)},
		  "-" => {:infix_or_postfix => Oper.new(10, :minus, :infix),
		  				:prefix => Oper.new(50, :uminus, :prefix)},
		  "*" => Oper.new(20, :mul,   :infix),
		  "/" => Oper.new(20, :div,   :infix),
		  "^" => Oper.new(30, :pow,   :infix),
		  "**" => Oper.new(30, :pow,  :infix),
		  "!" => Oper.new(30, :not,   :prefix),
		  "," => Oper.new(2,  :comma,   :infix),
		  "(" => Oper.new(99, nil,   :lp),
		  ")" => Oper.new(99, nil,   :rp)
		}
	
		ShuntingYard.new(opers,RPNOutput.new).shunt(SimpleLexer.new(a)).result
	end

	class SimpleLexer
		def initialize s 
			@s = s
			@s.gsub!('**', '^')
		end

		def each
		  @s.scan(/[ \r\n]*([0-9]+|[A-Za-z]+|\+\+|[\(\)+\-*\/\!,\^])[ \r\n]*/).each do |token|
		    token = token[0]
		    yield((?0 .. ?9).member?(token[0]) ? token.to_i : token)
		  end
		end
	end
	
	
	class Parser
		OPERANDS = ['+', '*', '-', '/', '^']
		
		def self.parse(string)
			post = Symbolic.shunt(string)
			parse_postfix(post)
		end
		
		def self.parse_postfix(post)
			# if only one token
			#if post.size == 1
			#	return determine_type(post.pop)
			#end
			# first 2 tokens must be operands
			stack = Array.new
			#p post
			#stack.push determine_type(post.reverse!.pop)
			#stack.push determine_type(post.pop)
			#post.reverse!
			post.each do |token|
				if token.is_a?(Symbol)
					if token == :plus
						e1 = stack.pop
						stack.push(stack.pop + e1)
					elsif token == :minus # binay minus
						e1 = stack.pop
						stack.push(stack.pop() - e1)
					elsif token == :uminus #unary minus
						stack.push(-stack.pop())
					elsif token == :mul
						e1 = stack.pop
						stack.push(stack.pop * e1)
					elsif token == :div
						e1 = stack.pop
						stack.push(stack.pop / e1)
					elsif token == :pow
						e1 = stack.pop
						stack.push(stack.pop ** e1)
					elsif token == :call
						e1 = stack.pop
						e2 = stack.pop
						stack.push(e2.arg(e1))
					end
				else
					stack.push determine_type(token)
				end
#				p stack
			end
			stack.pop
		end
	
		def self.determine_type(token) # returns a Float or a var
			if numeric?(token)
				if (Float(token).to_i.to_f == Float(token)) # an int!
					return Integer(token)
				else
					return Float(token)
				end
			else
				if Symbolic::Math.functions.has_key?(token.downcase) #todo arbitrary functions (unknown func)
					a = Symbolic::Math.functions[token.downcase]
				else
					a = var :name => token
				end
				return a
			end
		end
	
		def self.numeric?(object) # is object numeric
			true if Float(object) rescue false
		end
	end

end
