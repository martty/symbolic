#!/usr/bin/ruby

require File.dirname(__FILE__) + '/lib/symbolic.rb'
require File.dirname(__FILE__) + '/lib/symbolic/plugins/maxima.rb'

x = var :name => 'x'
f = 2*x + (1+5)**x + Symbolic::Math.log(x)
p f.to_s
p res = Symbolic.to_maxima("integrate("+f.to_s+", x);")
p sym = Symbolic::Parser.parse(res)
p syma = Symbolic.shunt(res)
p sym.to_s

g = Symbolic::Math.cos(x)*100*Symbolic::Math.log(6)
p g.to_s
#p post = Symbolic::Parser.to_postfix(raw)
#p sym = Symbolic::Parser.parse_postfix(post)
#p res = Symbolic.to_maxima("integrate(x**4, x);")
#p res
