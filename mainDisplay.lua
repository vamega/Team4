module(..., package.seeall)
gas = require "gas"
mainDisplay = display.newGroup()

function init_scale_values()
    xScaleMin = display.contentHeight/levels.background.contentWidth
    yScaleMin = display.contentHeight/levels.background.contentHeight
    
    if xScaleMin > yScaleMin then
        xScaleMin = yScaleMin
    else
        yScaleMin = xScaleMin
    end
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

-- Code to Handle zoom on the mainDisplay
-- create a table listener object for the background image
function mainDisplay:touch( event )
	local phase = event.phase
	local previousTouches = self.previousTouches
    -- The number of fingers on the screen
    local numTotalTouches = 1
    local last_time = 0
    
    --[[ Debugging code to test misclassigied touch ended events.
    local prevTouches = 1
    local box = display.newRect( 0, 0, 200, 200)
    local debug2 = display.newText(prevTouches, 60, 30, "Times New Roman", 48)
    local debug3 = display.newText(prevTouches, 0, 30, "Times New Roman", 48)
    debug3:setTextColor(0, 0, 0)
    debug2:setTextColor(0, 0, 0)
    --]]

	if ( previousTouches ) then
		-- add in total from previousTouches, subtract one if event is already in the array
		numTotalTouches = numTotalTouches + self.numPreviousTouches
		if previousTouches[event.id] then
			numTotalTouches = numTotalTouches - 1
		end
	end

	if "began" == phase then
        -- Don't add gas unless you have a single finger on the screen.
        -- Need to send gas the 
        if numTotalTouches == 1 then
            levels.scrollTouch(event)
        end
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
					--print( "distance = " .. self.distance )
				end
			end
		end

		if not previousTouches[event.id] then
			self.numPreviousTouches = self.numPreviousTouches + 1
		end
		previousTouches[event.id] = event
    
    elseif "moved" == phase then
        if self.isFocus then
            if numTotalTouches == 1 then
                levels.scrollTouch(event)
            end
        
			if ( self.distance ) then
				local dx,dy
				if previousTouches and ( numTotalTouches ) >= 2 then
					dx,dy = calculateDelta( previousTouches, event )
				end
	
				if ( dx and dy ) then
					local newDistance = math.sqrt( dx*dx + dy*dy )
					local scale = newDistance / self.distance
					--print( "newDistance(" ..newDistance .. ") / distance(" .. self.distance .. ") = scale("..  scale ..")" )
					if ( scale > 0 ) then
                        local tempXScale = self.xScaleOriginal * scale
                        local tempYScale = self.yScaleOriginal * scale
                        
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
        end
    elseif "ended" == phase or "cancelled" == phase then
		--[[ The idea here is to see if this touch ended signal is generated after an event that had 2 fingers on the screen.
        -- If it was then it was the extraneous event, generated when the second of two fingers stopped touching the screen.
        -- This however didn't seem to fix the issue.
        if numTotalTouches >= 2 then
            prevTouches = numTotalTouches
        end
        
        if numTotalTouches == 1 then
            if prevTouches == 1 then
                box:setFillColor(255,0,0)
                levels.scrollTouch(event)
            else
                prevTouches = 1
            end
        end--]]
        
        --[[
        Ugly hack, if a single-touch touch ended event is generated less than 200ms after a multitouch touch ended event,
        ignore it as it's caused by the second finger leaving the screen.
        --]]
        if numTotalTouches >= 2 then
            touch_time = system.getTimer()
        elseif numTotalTouches == 1 and system.getTimer() - touch_time > 200 then
            levels.scrollTouch(event)
        end
        
        if self.isFocus then
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
    
    --
    --[[ Debugging code to test a possible way to detect misclassified touch ended events
    -- A single finger touch ended event is generated after a multi-touch touch ended signal, resulting in code doing unintended things.
    debug2.text = prevTouches
    debug3.text = numTotalTouches
    box:toFront()
    debug2:toFront()
    debug3:toFront()
    --]]
    
	return true
end