math = require "math"
utils = require "utils"
sprite = require "sprite"
flammable = require "flammable"
explosives = require "explosives"
crate = require "crate"
water = require "water"

module(..., package.seeall)

function tutorial_level()
    crate.spawn_crate(400, 600)
    crate.spawn_crate(100, 100)
    explosives.spawn_barrel(150, 700)
    explosives.spawn_barrel(100, 800)
    myText = display.newText("Draw a gas line \nbetween the crates", 0, 200, "Helvetica", 48)
    myText:setTextColor(255, 255, 255)
    myText2 = display.newText("If you mess up,\nshake the phone to\nreset the level", 0, 500, "Helvetica", 48)
    water.load_water(300, 500)
    
end

function level_one()


end

function level_two()


end

function level_three()


end

function level_four()


end

function level_five()


end

function kill_level()


end