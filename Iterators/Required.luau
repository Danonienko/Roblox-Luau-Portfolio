--[[ 
	An iterator function for checking if a table is missing keys from another table
	
	**Example usage:**
	```luau
	local myTable = { Apple = "Apple" }
	local requiredKeys = { Apple = "Apple", Banana = "Banana" }

	for missingKeys in Required(myTable, requiredKeys) do
		print(`The target table is missing a '{missingKey}' key!`)
	end
	```
]]
--- @param target table — The table to check for missing keys
--- @param required table — The table containing the required keys (values are ignored)
--- @return The iterator function that returns missing keys one at a time
return function(target: { [string]: any }, required: { [string]: any }): () -> string?
	local missing: { string } = {}

	for key: string in pairs(required) do
		if target[key] == nil then
			table.insert(missing, key)
		end
	end

	local index: number = 0
	local count: number = #missing

	return function(): string?
		index += 1
		return index <= count and missing[index] or nil
	end
end
