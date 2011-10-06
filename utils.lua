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

--[[
This function calculates the distance between the two fingers
--]]
local function calculateDelta( previousTouches, event )
	local id,touch = next( previousTouches )
	if event.id == id then
		id,touch = next( previousTouches, id )
		assert( id ~= event.id )
	end

	local dx = touch.x - event.x
	local dy = touch.y - event.y
	return dx, dy
end