--!strict
--!native

--- An iterator function for checking if a table is missing keys from another table
--- @param target table — The table to check for missing keys
--- @param required table — The table containing the required keys (values are ignored)
--- @return The iterator function that returns a key that is missing in the target table
return function<K1, V1, K2, V2>(target: { [K1]: V1 }, required: { [K2]: V2 }): () -> string
	local missing: { string } = {}

	local targetTableIsArray: boolean = #target > 0
	local requiredTableIsArray: boolean = #required > 0

	if targetTableIsArray and requiredTableIsArray then
		-- Both tables are arrays

		local convertedTable: { [string]: V1 } = {}

		for index: K1, value: V1 in target do
			convertedTable[tostring(value)] = value
		end

		for index: K2, value: V2 in required do
			if convertedTable[(value :: any) :: string] ~= nil then
				continue
			end

			table.insert(missing, (value :: any) :: string)
		end
	end

	if not targetTableIsArray and not requiredTableIsArray then
		-- Both tables are key–value–pairs

		for key: K2, value: V2 in required do
			if target[(key :: any) :: K1] ~= nil then
				continue
			end

			table.insert(missing, (key :: any) :: string)
		end
	end

	if targetTableIsArray and not requiredTableIsArray then
		-- Target table is an array but required table is key–value–pairs

		local convertedTable: { [string]: V1 } = {}

		for index: K1, value: V1 in target do
			convertedTable[tostring(value)] = value
		end

		for key: K2, value: V2 in required do
			if convertedTable[(key :: any) :: string] ~= nil then
				continue
			end

			table.insert(missing, (key :: any) :: string)
		end
	end

	if not targetTableIsArray and requiredTableIsArray then
		-- Target table is key–value–pairs but required table is an array

		for index, value in target do
			if target[(value :: any) :: K1] ~= nil then
				continue
			end

			table.insert(missing, (value :: any) :: string)
		end
	end

	local index: number = 0

	return function(): string
		index += 1

		return missing[index]
	end
end
