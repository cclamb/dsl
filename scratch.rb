class Test
	def initilize
		@h = {}
	end
	def add(tag, &b)
		@h[tag] = b
	end
	def call
		@h.each do |x,y|
			puts x
			y.call
		end
	end
end
