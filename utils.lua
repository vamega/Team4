function index_of(table, value)
	for i,v in ipairs(table) do
		if v == value then
			return i
		end
	end
	
	return 0
end
