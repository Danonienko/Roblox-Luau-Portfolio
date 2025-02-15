--!strict

--[[ 
	An iterator function for checking if a table is missing keys from another table
	
	**Example usage:**
	```luau
	local myTable = { Apple = "Apple" }
	local requiredKeys = { Apple = "Apple", Banana = "Banana" }

	for missingKeys in missingKeys(myTable, requiredKeys) do
		print(`The target table is missing a '{missingKey}' key!`)
	end
	```
]]
--- @param target table — The table to check for missing keys
--- @param required table — The table containing the required keys (values are ignored)
--- @return The iterator function that returns a key that is missing in the target table
return function<V1, V2>(target: { V1 } | { [string]: V1 }, required: { string } | { [string]: V2 }): () -> string
	local missing: { string } = {}

	local targetTableIsArray: boolean = #target > 0 and true or false
	local requiredTableIsArray: boolean = #target > 0 and true or false

	if targetTableIsArray and requiredTableIsArray then
		-- Both tables are arrays

		local convertedTable: { [string]: V1 } = {}

		for index: number, value: V1 in target :: { V1 } do
			convertedTable[tostring(value)] = value
		end

		for _, value: string in required :: { string } do
			if convertedTable[value] ~= nil then
				continue
			end

			table.insert(missing, value)
		end
	end

	if not targetTableIsArray and not requiredTableIsArray then
		-- Both tables are key–value–pairs

		for key: string, _ in required :: { [string]: V2 } do
			if (target :: { [string]: V1 })[key] ~= nil then
				continue
			end

			table.insert(missing, key)
		end
	end

	if targetTableIsArray and not requiredTableIsArray then
		-- Target table is an array but required table is a key–value–pairs

		local convertedTable: { [string]: V1 } = {}

		for index: number, value: V1 in target :: { V1 } do
			convertedTable[tostring(value)] = value
		end

		for key: string, _ in required :: { [string]: V2 } do
			if convertedTable[key] ~= nil then
				continue
			end

			table.insert(missing, key)
		end
	end

	if not targetTableIsArray and requiredTableIsArray then
		-- Target tabe is a key–value–pairs but required table is an array

		for _, value: string in required :: { string } do
			if (target :: { [string]: V1 })[value] ~= nil then
				continue
			end

			table.insert(missing, value)
		end
	end

	local index: number = 0

	return function(): string
		index += 1
		return missing[index]
	end
end
