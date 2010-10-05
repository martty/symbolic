#!/usr/bin/ruby

require File.dirname(__FILE__) + '/lib/symbolic.rb'
#require File.dirname(__FILE__) + '/lib/symbolic/plugins/maxima.rb'

x = var :name => 'x'

p Symbolic::Backends.get_backends
Symbolic::Backends.use_backend('Dummy')
begin
	Symbolic::Backends::Capabilities.definite_integral('a','b', 'c')
rescue
	
end

Symbolic::Backends.use_backend('Maxima')
Symbolic::Backends::Capabilities.definite_integral('a','b', 'c')


#f = 2*x
#f.definite_integral('a', 'b', 'v')
