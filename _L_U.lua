--[[
	Copyright(C) 2016 Benjamin Moir
	
	Distributed under the Boost Software License, Version 1.0.
	(See accompanying file LICENSE_1_0.txt or http://www.boost.org/LICENSE_1_0.txt)
	
	_L_U Lib
	
	Adds _L and _U tables, for modifying and accessing
	local variables and upvalues.
--]]

_L = setmetatable({},
{
	__index = function(_, n)
		local i = 1
		while true do
			local vn, v = debug.getlocal(2, i)
			if not vn then break end
			if vn == n then
				return v
			end
			i = i + 1
		end
	end,
	
	__newindex = function(_, n, v)
		local i = 1
		while true do
			local vn = debug.getlocal(2, i)
			if not vn then break end
			if vn == n then
				debug.setlocal(2, i, v)
			end
			i = i + 1
		end
	end,
	
	__call = function()
		local vars = {}
		local i = 1
		while true do
			local n, v = debug.getlocal(2, i)
			if not n then break end
			vars[n] = v
			i = i + 1
		end
		return vars
	end,
})

_U = setmetatable({},
{
	__index = function(_, n)
		local f = debug.getinfo(2, "f").func
		local i = 1
		while true do
			local vn, v = debug.getupvalue(f, i)
			if not vn then break end
			if vn == n then
				return v
			end
			i = i + 1
		end
	end,
	
	__newindex = function(_, n, v)
		local f = debug.getinfo(2, "f").func
		local i = 1
		while true do
			local vn = debug.getupvalue(f, i)
			if not vn then break end
			if vn == n then
				debug.setupvalue(f, i, v)
			end
			i = i + 1
		end
	end,
	
	__call = function()
		local f = debug.getinfo(2, "f").func
		local vars = {}
		local i = 1
		while (true) do
			local n, v = debug.getupvalue(f, i)
			if not n then break end
			vars[n] = v
			i = i + 1
		end
		return vars
	end,
})
