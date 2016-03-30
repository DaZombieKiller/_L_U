# \_L\_U - Access Upvalues and Local Variables via String Names

\_L\_U is a Lua library that implements \_L and \_U tables, for accessing and modifying local variables and upvalues.

Snippet from example file (explaining the \_L table):

    -- The variable must be declared using the 'local' keyword first.
	-- Then we can modify and access it using the _L table.
	local local_variable
	
	-- Let's set it to "Hello World", then print it
	_L["local_variable"] = "Hello World"
	print(_L["local_variable"])
	
	-- If you wanted to make all local variables globals, then you
	-- would use this code:
	-- for k, v in pairs(_L) do _G[k] = v end

Upvalues are local variables from outer scopes that are accessed or modified within the current function.

Snippet from example file (explaining the \_U table):

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

\_L\_U is licensed under the Boost Software License, version 1.0

Note: \_L\_U makes use of the debug library, and thus will not work if it is disabled.