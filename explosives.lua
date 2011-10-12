math = require "math"
utils = require "utils"
sprite = require "sprite"
flammable_module = require "flammable"
flammable = flammable_module.flammable

module(..., package.seeall)

ghost_flag = false
barrel_lock = false

--animations
barrel_burning_sheet = sprite.newSpriteSheet("barrel_burning.png", 147, 200)
barrel_burning_set = sprite.newSpriteSet(barrel_burning_sheet, 1, 8)
--sprite.add(barrel_burning_set, "burning", 1, 8, 400)

--the list of all barrels
barrels = {}

--explosive barrels
barrel = {}
setmetatable(barrel, {__index = flammable})

function barrel:new(x, y)
    local barrelImage = sprite.newSprite(barrel_burning_set)
    barrelImage.x = x
    barrelImage.y = y
    mainDisplay:insert(barrelImage)
    local instance = flammable:new(barrelImage, {radius = 70})
	
    instance.body.isFixedRotation = true
	
    instance.body.density = 1
    instance.body.friction = 5
    
    --barrels catch fire more easily than crates
    instance.flash_point = instance.flash_point - 5
    instance.health = 80
    instance.max_burn_rate = 4
    
    --ghost stuff
    instance.ghost = nil
    
    setmetatable(instance, {__index = barrel})
    instance.body:addEventListener("touch", instance)
    
    return instance
end

function barrel:spawn_ghost()
    self.ghost = display.newImage(mainDisplay, "Range.png")
    self.ghost.x = self.body.x
    self.ghost.y = self.body.y + 25
end

function barrel:kill_ghost()
    if self.ghost ~= nil then
        self.ghost:removeSelf()
    end
end

function kill_ghosts()
    table_size = table.getn(barrels)
    for i=table_size, 1, -1 do
        barrels[i]:kill_ghost()
    end
end

function spawn_ghosts()
    table_size = table.getn(barrels)
    for i=table_size, 1, -1 do
        barrels[i]:spawn_ghost()
    end
end

function barrel:animate()
    if self.current_heat >= self.flash_point then
        --[[ghosts[utils.index_of(barrels, self)].x = self.body.x
        ghosts[utils.index_of(barrels, self)].y = self.body.y+25]]
        self.body.currentFrame = (80-self.health)/10
    else
    	self.body.currentFrame = 1
    end
end

--sets off the barrel when it's touched
function barrel:touch(event)
    if event.phase == "began"  and barrel_lock == false then
        barrel_lock = true
        self:apply_heat(self.flash_point)
        return true
    end
end

--makes the barrel explode shortly after catching fire
function barrel:on_enter_frame(elapsed_time)
	--update heat
	flammable.on_enter_frame(self, elapsed_time)
    if self.ghost ~= nil then
        self.ghost.x = self.body.x
        self.ghost.y = self.body.y + 25
    end
    --update animation
    self:animate()
end

--makes the barrel explode
function barrel:burn_up()
    if ghost_flag == true then
        self:kill_ghost()
	end
    table.remove(barrels, utils.index_of(barrels, self))
	
	flammable.burn_up(self)
	
	spawn_explosion(self.body.x, self.body.y, 200, self.burn_temperature)
end

function spawn_barrel(x, y)
    table.insert(barrels, barrel:new(x, y))
end

function spawn_explosion(x, y, radius, heat)
    for i, flammable_obj in ipairs(flammable_module.flammable_list) do
        local xDist = flammable_obj.body.x - x
        local yDist = flammable_obj.body.y - y
    	local dist_squared = xDist^2 + yDist^2
        if dist_squared < radius^2 then
            flammable_obj:apply_heat(heat)
            
            local dist = math.sqrt(dist_squared)
            local force = (radius - dist) * 20
            force = math.min(1500, force)
            
            flammable_obj.body:applyLinearImpulse(
            				force * xDist / dist,
            				force * yDist / dist,
            				flammable_obj.body.x, flammable_obj.body.y)
        end
    end
end

