import "CoreLibs/graphics"
import "CoreLibs/sprites"
local gfx<const> = playdate.graphics

-- main puzzle image, implemented using a tilemap
local puzzle = nil

-- selected column and line indexes
local selectedColumn, selectedLine = 1, 1

-- UI sprites for selected column and selected line
local uiSelectedColumn, uiSelectedLine = nil, nil

function makeTileMap(imageTable)
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

function drawLines(tileMap)
    local totalColumns, totalLines = tileMap:getSize()
    local tileWidth, tileHeight = tileMap:getTileSize()
    for column = 1, totalColumns do
        gfx.drawLine(column * tileWidth, 0, column * tileWidth,
                     totalLines * tileHeight)
    end
    for line = 1, totalLines do
        gfx.drawLine(0, line * tileHeight, totalColumns * tileWidth,
                     line * tileHeight)
    end

end

function selectColumn(tileMap, uiColumnSprite, uiLineSprite, column)
    local tileWidth, tileHeight = tileMap:getTileSize()
    uiLineSprite:remove()
    uiColumnSprite:moveTo(column * tileWidth - tileWidth / 2, 10)
    uiColumnSprite:add()
end

function selectLine(tileMap, uiColumnSprite, uiLineSprite, line)
    local tileWidth, tileHeight = tileMap:getTileSize()
    uiColumnSprite:remove()
    uiLineSprite:moveTo(10, line * tileHeight - tileHeight / 2)
    uiLineSprite:add()
end

function drawBackground()
    puzzle:draw(1, 1)
    drawLines(puzzle)
end

function gameSetup()
    local downIcon, errorMessage = gfx.image.new("Images/down")
    local rightIcon, errorMessage = gfx.image.new("Images/right")
    local images, errorMessage = gfx.imagetable.new("Images/kitten-drinking")
    puzzle = makeTileMap(images)
    shuffleMap(puzzle)
    gfx.setBackgroundColor(gfx.kColorClear)
    uiSelectedColumn = gfx.sprite.new(downIcon)
    uiSelectedLine = gfx.sprite.new(rightIcon)
    drawBackground()
end

gameSetup()
function playdate.update()
    if playdate.buttonJustPressed(playdate.kButtonRight) then
        selectedColumn = (selectedColumn < 4) and (selectedColumn + 1) or 1
        selectColumn(puzzle, uiSelectedColumn, uiSelectedLine, selectedColumn)
        drawBackground()
    end
    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        selectedColumn = (selectedColumn > 1) and (selectedColumn - 1) or 4
        selectColumn(puzzle, uiSelectedColumn, uiSelectedLine, selectedColumn)
        drawBackground()
    end
    if playdate.buttonJustPressed(playdate.kButtonDown) then
        selectedLine = (selectedLine < 4) and (selectedLine + 1) or 1
        selectLine(puzzle, uiSelectedColumn, uiSelectedLine, selectedLine)
        drawBackground()
    end
    if playdate.buttonJustPressed(playdate.kButtonUp) then
        selectedLine = (selectedLine > 1) and (selectedLine - 1) or 4
        selectLine(puzzle, uiSelectedColumn, uiSelectedLine, selectedLine)
        drawBackground()
    end
    gfx.sprite.update()
end
