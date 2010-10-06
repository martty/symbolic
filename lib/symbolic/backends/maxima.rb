class Symbolic::Backends::Maxima < Symbolic::Backends::Backend
	def to_maxima(maxstr)
		#p "maxima --very-quiet -r=\"#{maxstr}\""
		maxstr = "stardisp:true$ display2d:false$ "+maxstr+";" # so that i can input it back
		out = `maxima --very-quiet -r="#{maxstr}"`
		out.chomp.strip
	end
	
	def indefinite_integral(expr, with_respect_to)
		ret = to_maxima("integrate(#{expr.to_s}, #{with_respect_to})")
		return Symbolic::Parser.parse(ret)
	end
	
	def definite_integral(expr, with_respect_to, lower_limit, upper_limit)
		p "integrate(#{expr.to_s}, #{with_respect_to}, #{lower_limit}, #{upper_limit})"
		ret = to_maxima("integrate(#{expr.to_s}, #{with_respect_to}, #{lower_limit}, #{upper_limit})")
		return Symbolic::Parser.parse(ret)
	end
	
	def laplace(expr, with_respect_to, s_domain_variable = 's')
		ret = to_maxima("laplace(#{expr.to_s}, #{with_respect_to}, #{s_domain_variable})")
		return Symbolic::Parser.parse(ret)
	end
	
	def inverse_laplace(expr, with_respect_to, t_domain_variable)
		ret = to_maxima("ilt(#{expr.to_s}, #{with_respect_to}, #{t_domain_variable})")
		return Symbolic::Parser.parse(ret)
	end
end
