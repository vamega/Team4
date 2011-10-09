sprite = require "sprite"
physics = require "physics"
math = require "math"
utils = require "utils"
crate = require "crate"
--explosives = require "explosives"
gas = require "gas"
levels = require "levels"
water = require "water"
--require "collisionmanager"


--local intro = require("levels/intro")
local explosives = require("explosives")

system.activate( "multitouch" )

physics.start()
physics.setDrawMode("hybrid")
physics.setGravity(0, 0)

mainDisplay = display.newGroup()

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

-- Code to Handle zoom on the mainDisplay
-- create a table listener object for the background image
function mainDisplay:touch( event )
	local result = true
	local phase = event.phase
	local previousTouches = self.previousTouches

	local numTotalTouches = 1
	if ( previousTouches ) then
		-- add in total from previousTouches, subtract one if event is already in the array
		numTotalTouches = numTotalTouches + self.numPreviousTouches
		if previousTouches[event.id] then
			numTotalTouches = numTotalTouches - 1
		end
	end

	if "began" == phase then
		-- Very first "began" event
		if ( not self.isFocus ) then
			-- Subsequent touch events will target button even if they are outside the stageBounds of button
			display.getCurrentStage():setFocus( self )
			self.isFocus = true

			previousTouches = {}
			self.previousTouches = previousTouches
			self.numPreviousTouches = 0
		elseif ( not self.distance ) then
			local dx,dy

			if previousTouches and ( numTotalTouches ) >= 2 then
				dx,dy = calculateDelta( previousTouches, event )
			end

			-- initialize to distance between two touches
			if ( dx and dy ) then
				local d = math.sqrt( dx*dx + dy*dy )
				if ( d > 0 ) then
					self.distance = d
					self.xScaleOriginal = self.xScale
					self.yScaleOriginal = self.yScale
					print( "distance = " .. self.distance )
				end
			end
		end

		if not previousTouches[event.id] then
			self.numPreviousTouches = self.numPreviousTouches + 1
		end
		previousTouches[event.id] = event

	elseif self.isFocus then
		if "moved" == phase then
			if ( self.distance ) then
				local dx,dy
				if previousTouches and ( numTotalTouches ) >= 2 then
					dx,dy = calculateDelta( previousTouches, event )
				end
	
				if ( dx and dy ) then
					local newDistance = math.sqrt( dx*dx + dy*dy )
					local scale = newDistance / self.distance
					print( "newDistance(" ..newDistance .. ") / distance(" .. self.distance .. ") = scale("..  scale ..")" )
					if ( scale > 0 ) then
						self.xScale = self.xScaleOriginal * scale
						self.yScale = self.yScaleOriginal * scale
					end
				end
			end

			if not previousTouches[event.id] then
				self.numPreviousTouches = self.numPreviousTouches + 1
			end
			previousTouches[event.id] = event

		elseif "ended" == phase or "cancelled" == phase then
			if previousTouches[event.id] then
				self.numPreviousTouches = self.numPreviousTouches - 1
				previousTouches[event.id] = nil
			end

			if ( #previousTouches > 0 ) then
				-- must be at least 2 touches remaining to pinch/zoom
				self.distance = nil
			else
				-- previousTouches is empty so no more fingers are touching the screen
				-- Allow touch events to be sent normally to the objects they "hit"
				display.getCurrentStage():setFocus( nil )

				self.isFocus = false
				self.distance = nil
				self.xScaleOriginal = nil
				self.yScaleOriginal = nil

				-- reset array
				self.previousTouches = nil
				self.numPreviousTouches = nil
			end
		end
	end

	return false
end

--initialization
barrels = explosives.barrels
gas_nodes = gas.gas_nodes
waters = water.waters

--load test level
levels.tutorial_level()

    
--add invisible boundaries so that objects don't go offscreen
local top_edge = display.newRect(0, 0, levels.background.width, 10)
physics.addBody(top_edge, "static", {bounce = 0.4})
top_edge.isVisible = false
local left_edge = display.newRect(0, 0, 10, levels.background.height)
physics.addBody(left_edge, "static", {bounce = 0.4})
left_edge.isVisible = false
local right_edge = display.newRect(levels.background.width-10, 0, 10, levels.background.height)
physics.addBody(right_edge, "static", {bounce = 0.4})
right_edge.isVisible = false
local bottom_edge = display.newRect(0, levels.background.height-10, levels.background.width, 10)
physics.addBody(bottom_edge, "static", {bounce = 0.4})
bottom_edge.isVisible = false

mainDisplay:insert(top_edge)
mainDisplay:insert(left_edge)
mainDisplay:insert(right_edge)
mainDisplay:insert(bottom_edge)

--calls on_enter_frame for all items in the given table
local function update_all(table_to_update, elapsed_time)
	for i, object in ipairs(table_to_update) do
		object:on_enter_frame(elapsed_time)
	end
end


level = 0
spawned = true

--game loop
local last_frame_time = 0
local function on_enter_frame(event)
    --collisionManager = CollisionManagerBuilder:new()
    --collisionManager:addCollisionTables(gas.gas_nodes, water.waters)
	local elapsed_time = (event.time - last_frame_time) / 1000
	elapsed_time = math.min(0.2, elapsed_time)
	
	last_frame_time = event.time
	
	update_all(flammable_module.flammable_list, elapsed_time)
	
    if spawned == false then
        print ("spawning level")
        if level == 0 then
            levels.tutorial_level()
        end
        if level == 1 then
            levels.level_one()
        end
        spawned = true
    end
    
    if crate.crates.size==0 and table.getn(explosives.barrels)==0 then
        levels.kill_level()
        level = level+1
        spawned = false
    end
end

--event listeners
Runtime:addEventListener("touch", gas.add_gas)
Runtime:addEventListener("accelerometer", gas.erase_gas)
Runtime:addEventListener("enterFrame", on_enter_frame)
mainDisplay:addEventListener( "touch", mainDisplay )
