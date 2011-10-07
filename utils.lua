module(..., package.seeall)

function index_of(table, value)
	for i,v in ipairs(table) do
		if v == value then
			return i
		end
	end
	
	return 0
end

function dist_squared(x1, y1, x2, y2)
    return (x1-x2)^2 + (y1-y2)^2
end