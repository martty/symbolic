module Symbolic
	def self.to_maxima(maxstr)
		#p "maxima --very-quiet -r=\"#{maxstr}\""
		maxstr = "stardisp:true$ display2d:false$ "+maxstr # so that i can input it back
		out = `maxima --very-quiet -r="#{maxstr}"`
		out.chomp.strip
	end
end
