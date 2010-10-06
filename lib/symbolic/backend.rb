class Symbolic::Backends
	@@current_backend = nil
	
	def self.get_backends
		self.constants.reject{|x| x == :Capabilities || x == :Backend }
	end
	
	def self.use_backend(backend_name)
		#p "using "+backend_name.to_sym
		if self.get_backends.include?backend_name.to_sym
			if @@current_backend  # if there was a previous backend
				release
			end
			@@current_backend = eval("#{backend_name}.new")
			@@current_backend.on_load
		else
			raise "No such backend available"
		end
	end
	
	def self.get_current_backend
		@@current_backend
	end
	
	def self.release
		@@current_backend.on_unload if @@current_backend
		@@current_backend = nil
	end
	
	module Capabilities
		def self.responds_to?(sym) # we take eeeverything symbolic doesn't take by default
			return true
		end
		
		def self.method_missing(operation, *args) # any non-symbolic method will be sent to the backend
			Symbolic::Backends.get_current_backend.send(operation, *args)
		end
		
		def method_missing(operation, *args) # any non-symbolic method will be sent to the backend
			args.reverse!.push(self).reverse!
			Symbolic::Backends.get_current_backend.send(operation, *args)
		end
		
		def self.included(klass)
#  	  (klass.instance_methods & self.instance_methods).each do |method|
#	      klass.instance_eval{remove_method method.to_sym}
#	    end
	  end
	end
	
end

class Symbolic::Backends::Backend
	def on_load
	end
	
	def on_unload
	end
	
	def method_missing(operation, *args) # no such capability exists
		raise operation.to_s+" unsupported by "+Symbolic::Backends.get_current_backend.class.simple_name+" backend."
	end
end

class Symbolic::Backends::Dummy < Symbolic::Backends::Backend
	def on_load
		p "loading Dummy"
	end
	
	def on_unload
		p "unloading Dummy"
	end
end

module Symbolic
#	include Backends::Capabilities
	class Expression
		include Backends::Capabilities
	end
end

require File.dirname(__FILE__) + '/backends/maxima.rb'
