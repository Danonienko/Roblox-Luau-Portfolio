--!strict
--!native

--- An iterator function for checking if a table is missing keys from another table
--- @param target table — The table to check for missing keys
--- @param required table — The table containing the required keys (values are ignored)
--- @return The iterator function that returns a key that is missing in the target table
return function<K1, V, K2>(target: { [K1]: V }, required: { [K2]: string }): () -> string
	local missing: { string } = {}

	local convertedTable: { [string]: V } = {}

	for key: K1, value: V in target do
		convertedTable[tostring(value)] = value
	end

	for key: K2, value: string in required do
		if convertedTable[value] ~= nil then
			continue
		end

		table.insert(missing, value)
	end

	local index: number = 0

	return function(): string
		index += 1

		return missing[index]
	end
end
