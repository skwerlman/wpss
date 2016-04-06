return function(...)
	local obj = {}
	function obj:catch(anotherThing)
			if not self.status then
				return anotherThing(self.result)
			else
				return self.result
			end
	end
	obj.status, obj.result = pcall(...)
	return obj
end
