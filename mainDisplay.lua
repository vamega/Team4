module(..., package.seeall)
gas = require "gas"
mainDisplay = display.newGroup()

function init_scale_values()
    xScaleMin = display.contentHeight/levels.background.contentWidth
    yScaleMin = display.contentHeight/levels.background.contentHeight
    
    if xScaleMin < yScaleMin then
        xScaleMin = yScaleMin
    else
        yScaleMin = xScaleMin
    end
end

numFingersDown = 0

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
        numFingersDown = numFingersDown + 1
        gas.add_gas(event)
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
            if numFingersDown == 1 then
                return false
            end
        
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
                        local tempXScale = self.xScaleOriginal * scale
                        local tempYScale = self.yScaleOriginal * scale
                        
                        --self.xScale = tempXScale
                        --self.yScale = tempYScale
                        ---[[
                        if xScaleMin > tempXScale then
                            self.xScale = xScaleMin
                        elseif tempXScale > 1 then
                            self.xScale = 1
                        else
                            self.xScale = tempXScale
                        end
                        
                        if yScaleMin > tempYScale then
                            self.yScale = yScaleMin
                        elseif tempYScale > 1 then
                            self.yScale = 1
                        else
                            self.yScale = tempYScale
                        end
                        --]]
					end
				end
			end

			if not previousTouches[event.id] then
				self.numPreviousTouches = self.numPreviousTouches + 1
			end
			previousTouches[event.id] = event

		elseif "ended" == phase or "cancelled" == phase then
            numFingersDown = numFingersDown - 1
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

	return true
end