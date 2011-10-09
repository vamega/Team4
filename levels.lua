math = require "math"
utils = require "utils"
sprite = require "sprite"
flammable = require "flammable"
barrel = require "explosives"
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
    barrel.spawn_barrel(100, 100)
    crate.spawn_crate(100, 200)
    if display.contentHeight <800 then
        crate.spawn_crate(100, display.contentHeight -100)
    else
        crate.spawn_crate(100, 700)
    end

end

function level_one()
    barrel.spawn_barrel(100, 100)
    crate.spawn_crate(200,100)
    crate.spawn_crate(display.contentWidth-100, display.contentHeight-100)
    text[1]= display.newText("Draw a gas line \nbetween the crate\nand barrel", 0, 200, "Helvetica", 48)
    text[1]:setTextColor(255, 255, 255)
    text[2] = display.newText("If you mess up,\nshake the phone to\nreset the level", 0, 500, "Helvetica", 48)
    text[2]:setTextColor(255, 255, 255)

end

function level_two()
    crate.spawn_crate(50, 50)
    crate.spawn_crate(50, 700)
    crate.spawn_crate(400, 300)
    barrel.spawn_barrel(100, 150)
    barrel.spawn_barrel(100, 150)
    barrel.spawn_barrel(100, 150)
    barrel.spawn_barrel(100, 150)

end

function level_three()
crate.spawn_crate(400, 600)
    crate.spawn_crate(100, 100)
    barrel.spawn_barrel(150, 700)
    barrel.spawn_barrel(100, 800)

end

function level_four()


end

function level_five()


end