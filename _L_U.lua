--
-- _L_U - local and upvalue access library for Lua
--
-- Copyright(C) 2016 Benjamin Moir
-- Distributed under the Boost Software License, Version 1.0.
-- (See accompanying file LICENSE_1_0.txt or http://www.boost.org/LICENSE_1_0.txt)
--

setmetatable(_G,
{
	__index = function(t, k)
		if k == "_L" then
			-- Get locals table
			local _L_WEAK = {}
			local i = 1
			while true do
				local n, v = debug.getlocal(2, i)
				if not n then break end
				_L_WEAK[n] = v
				i = i + 1
			end
			
			-- Metamethods
			local _L = {}
			setmetatable(_L,
			{
				__index = function(t, k)
					return _L_WEAK[k]
				end,
				
				__newindex = function(t, k, v)
					local i = 1
					while true do
						local n = debug.getlocal(2, i)
						if not n then break end
						if n == k then
							debug.setlocal(2, i, v)
							_L_WEAK[k] = v
						end
						i = i + 1
					end
				end,
			})
			
			-- Return table
			return _L
		elseif k == "_U" then
			-- Get upvalue table
			local _U_WEAK = {}
			local f = debug.getinfo(2, "f").func
			local i = 1
			while true do
				local n, v = debug.getupvalue(f, i)
				if not n then break end
				_U_WEAK[n] = v
				i = i + 1
			end
			
			-- Metamethods
			local _U = {}
			setmetatable(_U,
			{
				__index = function(t, k)
					return _U_WEAK[k]
				end,
				
				__newindex = function(t, k, v)
					local f = debug.getinfo(2, "f").func
					local i = 1
					while true do
						local n = debug.getupvalue(f, i)
						if not n then break end
						if n == k then
							debug.setupvalue(f, i, v)
							_U_WEAK[k] = v
						end
						i = i + 1
					end
				end,
			})
			
			-- Return table
			return _U
		else
			return rawget(t, k)
		end
	end,
	
	__newindex = function(t, k, v)
		if k ~= "_L" and k ~= "_U" then
			rawset(_G, k, v)
		end
	end,
})
