math = require "math"
utils = require "utils"
sprite = require "sprite"
flammable = require "flammable"
explosives = require "explosives"
crate = require "crate"
water = require "water"

module(..., package.seeall)

text = {}

function kill_level()
    table_size = table.getn(text)
    for i=1, table_size do
        display.remove(text[i])
    end
    
end

function tutorial_level()
    --background
    background = display.newImage("background.png")
    mainDisplay:insert(background)
    
    crate.spawn_crate(400, 600)
    crate.spawn_crate(100, 100)
    explosives.spawn_barrel(150, 700)
    explosives.spawn_barrel(100, 800)
    text[1]= display.newText("Draw a gas line \nbetween the crates", 0, 200, "Helvetica", 48)
    text[1]:setTextColor(255, 255, 255)
    text[2] = display.newText("If you mess up,\nshake the phone to\nreset the level", 0, 500, "Helvetica", 48)
    text[2]:setTextColor(255, 255, 255)
    --water.load_water(300, 500)
    
end

function level_one()
    --background
    background = display.newImage("background.png")
    mainDisplay:insert(background)
    
    crate.spawn_crate(50, 50)
    crate.spawn_crate(50, 700)
    crate.spawn_crate(400, 300)
    explosives.spawn_barrel(100, 150)
    explosives.spawn_barrel(100, 150)
    explosives.spawn_barrel(100, 150)
    explosives.spawn_barrel(100, 150)
    
end

function level_two()


end

function level_three()


end

function level_four()


end

function level_five()


end