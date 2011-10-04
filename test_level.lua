display.setStatusBar( display.HiddenStatusBar );
--Easy Test Level

--background
local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0, 0, 0)

--start barrel
local barrel = display.newRect(50, 50, 20, 20)
barrel:setFillColor(0,200,0)

--end object
local object = display.newRect(410,50, 20, 20)
object:setFillColor(200,0,0)

--borders
local border1 = display.newRect(95, 51, 5, 700)
border1:setFillColor(200,200,200)
local border2 = display.newRect(95, 751, 295, 5)
border2:setFillColor(200,200,200)
local border3 = display.newRect(385, 51, 5, 700)
border3:setFillColor(200,200,200)


