--!strict
--!native

--- An iterator function for checking if a value of a key is of correct type
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
	else
		-- The table is a key–value–pairs

		for key: string, value: T in t :: { [string]: T } do
			if (typeof(value) == "Instance" and value.Name == type) or typeof(value) == type then
				continue
			end

			(wrongKeyValueTypes :: { [string]: T })[key] = value
		end
	end

	local localTableIsAnArray: boolean = #wrongKeyValueTypes > 0 and true or false

	if localTableIsAnArray then
		-- The local table is an array

		local index: number = 0

		return function(): (string?, T)
			index += 1

			return index <= #wrongKeyValueTypes and tostring(index) or nil, (wrongKeyValueTypes :: { T })[index]
		end
	else
		-- The local table is a key–value–pairs

		local key: string?, value: T

		return function(): (string?, T)
			key, value = next(wrongKeyValueTypes :: { [string]: T }, key)

			return key, value
		end
	end
end
