#!/usr/bin/ruby

require File.dirname(__FILE__) + '/lib/symbolic.rb'
require File.dirname(__FILE__) + '/lib/symbolic/plugins/maxima.rb'

x = var :name => 'x'
f = 2*x + (1+5)**x + Symbolic::Math.log(x)
p f.to_s
p f
#p res = Symbolic.to_maxima("integrate("+f.to_s+", x);")
#p sym = Symbolic::Parser.parse(res)
#p syma = Symbolic.shunt(res)
#p sym.to_s

y = var :name => 'y'

p sym = Symbolic::Parser.parse('(y+3)*(x+2)*4')
p sym.to_s
p g = 4*(y+3)*(x+2)
p g.to_s

p sym.to_s

#g = Symbolic::Math.cos(x)*100*Symbolic::Math.log(6)
#p g.to_s
#p post = Symbolic::Parser.to_postfix(raw)
#p sym = Symbolic::Parser.parse_postfix(post)
#p res = Symbolic.to_maxima("integrate(x**4, x);")
#p res
