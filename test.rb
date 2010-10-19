#!/usr/bin/ruby

require File.dirname(__FILE__) + '/lib/symbolic.rb'
#require File.dirname(__FILE__) + '/lib/symbolic/plugins/maxima.rb'

x = var :name => 'x'

p Symbolic::Backends.get_backends
f = 2*x + 5

Symbolic::Backends.use_backend('Maxima')
nt = var :name => 'T'
k = var :name => 'k'
w = var :name => 'w'
t = var :name => 't'

#p f.indefinite_integral('x')

#ab = 10*Symbolic::Math.sin(k*w*t)
#p ab
#p ab.definite_integral('t', 0, 'T/2')
#ub = nt/2 * ab.definite_integral('t', 0, 'T/2')
#p ub
#p f.indefinite_integral('x')
#p f.definite_integral('x','a', 'b')
#p g = f.laplace('x')
#p g.inverse_laplace('s', 'x')
e1 = f.equals(x+4)
p e1
p e1.to_zero
p e1.to_s
p e1 == e1.to_zero
#p e1.for_var(x)
