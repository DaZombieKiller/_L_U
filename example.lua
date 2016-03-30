--
-- _L_U example file
--
-- Copyright(C) 2016 Benjamin Moir
-- Distributed under the Boost Software License, Version 1.0.
-- (See accompanying file LICENSE_1_0.txt or http://www.boost.org/LICENSE_1_0.txt)
--

-- Enable the _L and _U tables
require "_L_U"

-- The variable must be declared using the 'local' keyword first.
-- Then we can modify and access it using the _L table.
local local_variable

-- Let's set it to "Hello World", then print it
_L["local_variable"] = "Hello World"
print(_L["local_variable"])

-- If you wanted to make all local variables global, then you
-- would use this code:
-- for k, v in pairs(_L) do _G[k] = v end

-- Upvalues are local variables from
-- outer scopes, that are used in the current function.
-- They can be modified and accessed with the _U table.
function scope_1()
	-- Declare a local variable in scope_1
	local scoped_variable = 2
	
	-- Inside scope_1, we have a function called
	-- scope_2
	function scope_2()
		-- Use scoped_variable within scope_2 in any way
		-- If we don't use it then we cannot access it
		-- with _U (we will get nil instead)
		-- I recommend just setting the variable to itself
		-- as a way of declaring it as an upvalue
		scoped_variable = scoped_variable
		
		-- We can now access "scoped_variable" using _U
		-- Let's try printing it
		print(_U["scoped_variable"])
		
		-- We can also access "local_variable" from love.load
		local_variable = local_variable
		print(_U["local_variable"])
		
		-- upvalues can be transformed into globals too
		-- for k, v in pairs(_U) do _G[k] = v end
	end
	
	-- Call scope_2
	scope_2()
end

-- Call scope_1
scope_1()

-- Additional notes/summary
-- * You cannot use _L to declare a local variable, it must
--   already be declared using the 'local' keyword.
-- * You cannot use _U to declare an upvalue, it will automatically
--   be declared an upvalue when it is used in the function.
-- * _L and _U use functions from the debug table, thus disabling
--   the debug table will prevent them from functioning. The specific
--   debug functions that are used are:
--    * debug.getlocal
--    * debug.setlocal
--    * debug.getinfo
--    * debug.getupvalue
--    * debug.setupvalue
