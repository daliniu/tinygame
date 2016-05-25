require("script/lib/basefunctions")

local DataCache = gf_class()

function DataCache:ctor(__size)
	self.size = __size
	self.capacity = 0
	self.dt = {}
end

function DataCache:data()
	return self.dt
end

function DataCache:clear()
	self.capacity = 0
	self.dt = {}
end

function DataCache:push(e)
	self.capacity = self.capacity + 1
	if self.capacity >= self.size then
		self.capacity = 1
	end
	self.dt[self.capacity] = e
	return self.capacity
end

function DataCache:erase(k)
	--table.remove(self.dt, k)
	self.dt[k] = nil
end

function DataCache:get(k)
	return self.dt[k]
end

return DataCache
