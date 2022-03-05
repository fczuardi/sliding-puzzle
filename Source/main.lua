import "CoreLibs/graphics"
local gfx<const> = playdate.graphics

local baseImagePath = "Images/kitten-drinking"

-- main puzzle image, implemented using a tilemap
local map = nil

function makeMap(imageTable)
    local totalTiles = imageTable:getLength()
    local totalColumns, totalLines = imageTable:getSize()
    local map = gfx.tilemap.new()
    map:setImageTable(imageTable)
    map:setSize(totalColumns, totalLines)
    for column = 1, totalColumns do
        for line = 1, totalLines do
            local tileNumber = totalColumns * (line - 1) + column
            map:setTileAtPosition(column, line, tileNumber)
        end
    end
    return map
end

function swapTiles(tileMap, xA, yA, xB, yB)
    local tileNumberA = tileMap:getTileAtPosition(xA, yA)
    local tileNumberB = tileMap:getTileAtPosition(xB, yB)
    tileMap:setTileAtPosition(xA, yA, tileNumberB)
    tileMap:setTileAtPosition(xB, yB, tileNumberA)
end

function shuffleMap(tileMap)
    local totalColumns, totalLines = tileMap:getSize()
    for column = 1, totalColumns do
        for line = 1, totalLines do
            swapTiles(tileMap, column, line, math.random(1, totalColumns),
                      math.random(1, totalLines))
        end
    end
end

function gameSetup()
    local images, errorMessage = gfx.imagetable.new(baseImagePath)
    assert(images, errorMessage)
    map = makeMap(images)
    shuffleMap(map)
    map:draw(1, 1)
end

gameSetup()
function playdate.update()
end
