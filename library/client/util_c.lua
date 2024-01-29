local screen = {guiGetScreenSize()}
local SvgsRectangle = { };

_dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, ...)

    return _dxDrawText(tostring(text), x, y, (x + w), (y + h), ...)

end

function createColor(colorTable, alpha)
    return tocolor(colorTable[1], colorTable[2], colorTable[3], alpha)
end


function dxDrawBordRectangle(x, y, w, h, radius, color, post)
    if not SvgsRectangle[radius] then
        local Path = string.format([[
            <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/>
            </svg>
        ]], w, h, w, h, w, h, radius)
        SvgsRectangle[radius] = svgCreate(w, h, Path)
    end
    if SvgsRectangle[radius] then
        --('add')
        dxDrawImage(x, y, w, h, SvgsRectangle[radius], 0, 0, 0, color, post)
        --dxSetBlendMode('blend')
    end
end


    --// Number  //--

function dxDrawCircle(centerX, centerY, radius, color, segments, player)
    segments = segments or 30
    local angleStep = 360 / segments

    local playerX, playerY, playerZ
    if player then
        playerX, playerY, playerZ = getElementPosition(player)
    else
        playerX, playerY, playerZ = 0, 0, 0
    end

    for i = 1, segments do
        local angle1 = math.rad(angleStep * (i - 1))
        local angle2 = math.rad(angleStep * i)

        local x1 = centerX + radius * math.cos(angle1)
        local y1 = centerY + radius * math.sin(angle1)
        local x2 = centerX + radius * math.cos(angle2)
        local y2 = centerY + radius * math.sin(angle2)

        local dist1 = getDistanceBetweenPoints2D(playerX, playerY, x1, y1)
        local dist2 = getDistanceBetweenPoints2D(playerX, playerY, x2, y2)

        dxDrawLine(x1, y1, x2, y2, color, 2)
    end
end


--------
    --// Mouse  //--

function isCursorOnElement ( x, y, w, h )
    local mx, my = getCursorPosition ()
    local fullx, fully = guiGetScreenSize ()
    cursorx, cursory = mx*fullx, my*fully
    if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
        return true
    else
        return false
   end
end
