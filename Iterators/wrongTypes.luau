--!strict
--!native

--- An iterator function for checking if a value of a key is of correct type
--- @param t table — The table to check
--- @param type string — The name of the type to check for
--- @return The iterator function that returns a key and value pairs where value is of incorrect type
return function<K, V>(t: { [K]: V }, type: string): () -> (K?, V)
	local wrongTypes: { [K]: V } = {}

	for key: K, value: V in t do
		if (typeof(value) == "Instance" and value.ClassName == type) or typeof(value) == type then
			continue
		end

		wrongTypes[key] = value
	end

	local key: K?, value: V

	return function(): (K?, V)
		key, value = next(wrongTypes)

		return key, value
	end
end
