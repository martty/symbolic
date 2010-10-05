class Symbolic::Backends::Maxima < Symbolic::Backends::Backend
	def self.to_maxima(maxstr)
		#p "maxima --very-quiet -r=\"#{maxstr}\""
		maxstr = "stardisp:true$ display2d:false$ "+maxstr # so that i can input it back
		out = `maxima --very-quiet -r="#{maxstr}"`
		out.chomp.strip
	end
	
	def hello
		p "hello!"
	end
	def indefinite_integral(with_respect_to)
		p "indefinite"
	end
	
	def definite_integral(with_respect_to, lower_limit, upper_limit)
		p "definite"
	end
end
