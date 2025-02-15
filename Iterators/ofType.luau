--!strict

--[[
	An iterator function for checking if a value of a key is of correct type
	
	**Example usage:**
	```luau
	local myTable = { "StringValue", "AnotherStringValue", 3 }

	for _, wrongTypeValue in ofType(myTable, "string") do
		print(`'{wrongTypeValue}' is expected to be a 'string', got '{typeof(wrongTypeValue)}' instead`)
	end
	```
]]
--- @param t table — The table to check
--- @param type string — The name of the type to check for
--- @return The iterator function that returns a key and value pairs where value is of incorrect type
return function<T>(t: { T } | { [string]: T }, type: string): () -> (string?, T)
	local wrongKeyValueTypes: { T } | { [string]: T } = {}

	local tableIsAnArray: boolean = #t > 0 and true or false

	if tableIsAnArray then
		-- The table is an array

		for index: number, value: T in t :: { T } do
			if (typeof(value) == "Instance" and value.Name == type) or typeof(value) == type then
				continue
			end

			table.insert(wrongKeyValueTypes :: { T }, value :: T)
		end
	end

	local isAnArray: boolean = #wrongKeyValueTypes > 0 and true or false

	if isAnArray then
		-- The table is an array

		local index: number = 0

		return function(): (string?, T)
			index += 1

			return index <= #wrongKeyValueTypes and tostring(index) or nil, (wrongKeyValueTypes :: { T })[index]
		end
	else
		-- The table is a key–value–pairs

		local key: string?, value: T

		return function(): (string?, T)
			key, value = next(wrongKeyValueTypes :: { [string]: T }, key)

			return key, value
		end
	end
end
