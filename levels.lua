math = require "math"
utils = require "utils"
sprite = require "sprite"
flammable = require "flammable"
explosives = require "explosives"
crate = require "crate"
water = require "water"

module(..., package.seeall)

function tutorial_level()
    crate.spawn_crate(100, 600)
    crate.spawn_crate(100, 100)
    crate.spawn_crate(200,300)
    explosives.spawn_barrel(150, 200)
    explosives.spawn_barrel(200, 600)
    explosives.spawn_barrel(200, 350)
    explosives.spawn_barrel(150, 400)
    water.load_water(300, 500)
    myText = display.newText("Draw a gas line between the crates", 0, 200, "Helvetica", 48)
    myText:setTextColor(255, 255, 255)

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