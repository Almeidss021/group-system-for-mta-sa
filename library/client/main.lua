--[[
 █▀▀█ █▄░▒█ █▀▀▄ █▀▀█ █▀▀▀ █░░▒█  
 █▄▄█ █▒█▒█ █░▒█ █▄▄▀ █▀▀▀ █▄▄▄█  
 █░▒█ █░░▀█ █▄▄▀ █░▒█ █▄▄▄ ░▒█░░  
]]

local screen = {guiGetScreenSize()}; 
local scale = math.min(math.max(0.80, screen[2]/1080), 2)

local Global_C = {
    ['Var'] = {
        ['Visible'] = false;
        ['Route'] = {0, 1};
        ['Tick'] = nil;
        ['Window'] = { };
        ['typePanel'] = false;
        ['transitionStartTime'] = 0; 
        ['transitionDuration'] = 900;  
        ['maxLines'] = 8;
        ['resultTable'] = { };
        ['Select'] = 0;
    };

    ['tabData'] = {
        [1] = 'Inicial',
        [2] = 'Membros',
        [3] = 'Recrutar',
    }; 
};

local dxDraw = {
	['Sizes'] = { 
		['Rectangle'] = {width = 600 * scale, height = 500 * scale};
		['Rectangle_bar'] = {width = 200 * scale, height = 500 * scale};
		['Rectangle_mov'] = {width = 5 * scale, height = 20 * scale};
		['text_bar'] = {width = 80 * scale, height = 60 * scale};
	};
	['ImageSize'] = {
		['Icons'] = {width = 430 * scale, height = 60 * scale}; 
	};
    ['Font'] = {
        [1] = dxCreateFont('library/assets/font/font.ttf', 10 * scale);
        [2] = dxCreateFont('library/assets/font/font.ttf', 12 * scale);
        [3] = dxCreateFont('library/assets/font/font.ttf', 9.5 * scale);
    }; 
}

local scrollData = {}


function Groups()
	dxDrawBordRectangle( (screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2, dxDraw['Sizes']['Rectangle']['width'], dxDraw['Sizes']['Rectangle']['height'], 10, createColor(Config['Colors']['Color_bg']), false)
    dxDrawBordRectangle( (screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2, dxDraw['Sizes']['Rectangle_bar']['width'], dxDraw['Sizes']['Rectangle_bar']['height'], 10, createColor(Config['Colors']['Color_bar']), false)
	 dxDrawBordRectangle( (screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 205 * scale, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2, dxDraw['Sizes']['Rectangle_bar']['width'] - 100 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 100 * scale, 10, createColor(Config['Colors']['Color_bar']), false)
    if Config['Groups_Name'][Global_C['Var']['typePanel']] then
		for i, v in ipairs(Config['Groups_Name'][Global_C['Var']['typePanel']]) do
			dxDrawText(v['Name'],(screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2,(screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 + 5 * scale,dxDraw['Sizes']['Rectangle_bar']['width'],dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale, createColor(Config['Colors']['Color_text']), 1.00, dxDraw['Font'][2], 'center', 'center',  false, false, false, false, false)
		end
	end
	for i, tab in ipairs(Global_C['tabData']) do
		dxDrawText( tab, (screen[1] - dxDraw['Sizes']['Rectangle_bar']['width']) / 2 - 180 * scale, ((screen[2] - dxDraw['Sizes']['Rectangle_bar']['height']) / 2) + (50 + 10 + 5) * i * scale, dxDraw['Sizes']['text_bar']['width'], dxDraw['Sizes']['text_bar']['height'],  (Global_C['Var']['Window'] == tab and createColor(Config['Colors']['Color_all']) or createColor(Config['Colors']['Color_text'])), 1.00, dxDraw['Font'][1], 'left', 'center',  false, false, false, false, false)
	    if Global_C['Var']['Visible'] and Global_C['Var']['transitionStartTime'] ~= 0 then
	        updateMovbar()
	   	end
	end
	if Global_C['Var']['Window'] == 'Inicial' then 

	elseif Global_C['Var']['Window'] == 'Membros' then 
		dxDrawBordRectangle((screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 205 * scale, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 + 10 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] + 180 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 68 * scale, 10, createColor(Config['Colors']['Color_bar']), false)
		dxDrawBordRectangle((screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 205 * scale, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 + 445 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] - 10 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale, 11, isCursorOnElement((screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 205 * scale, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 + 445 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] - 10 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale) and createColor(Config['Colors']['Button_color']) or createColor(Config['Colors']['Color_grid']), false)
		dxDrawBordRectangle((screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 398 * scale, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 + 445 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] - 10 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale, 11, isCursorOnElement((screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 398 * scale, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 + 445 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] - 10 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale) and createColor(Config['Colors']['Button_color2']) or createColor(Config['Colors']['Color_grid']), false)
		dxDrawText('Expulsar', (screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 205 * scale, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 + 445 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] - 10 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale, createColor(Config['Colors']['Color_text']), 1.00, dxDraw['Font'][1], 'center', 'center', false, false, false, false, false)
		dxDrawText('Tornar Lider', (screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 398 * scale, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 + 445 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] - 10 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale,  createColor(Config['Colors']['Color_text']), 1.00, dxDraw['Font'][1], 'center', 'center', false, false, false, false, false)
		dxDrawScrollBar('Scroll_info', (screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 588 * scale, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 + 10 * scale, 8 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 68 * scale, Global_C['Var']['maxLines'], (#Global_C['Var']['resultTable'] <= Global_C['Var']['maxLines'] and Global_C['Var']['maxLines'] or #Global_C['Var']['resultTable']))
		lines = 0
		for k, j in ipairs(Global_C['Var']['resultTable'] or { }) do
           	if (k > scrollData['Scroll_info:Offset'] and lines < Global_C['Var']['maxLines']) then
            	lines = lines + 1
				dxDrawBordRectangle((screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 205 * scale, ((screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 ) + (38 + 10 + 5) * scale * lines - 37 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] + 180 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale, 10, (Global_C['Var']['Select'] == k and createColor(Config['Colors']['Color_all']) or createColor(Config['Colors']['Color_grid'])), false)
				dxDrawText(j['Account']..' (ID:'..j['id']..')', (screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 210 * scale, ((screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 ) + (38 + 10 + 5) * scale * lines - 37 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] - 100 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale, createColor(Config['Colors']['Color_text']), 1.00, dxDraw['Font'][3], 'left', 'center', false, false, false, false, false)
				dxDrawText(j['Ultimavezonline'], (screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 195 * scale, ((screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 ) + (38 + 10 + 5) * scale * lines - 37 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] + 180 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale, createColor(Config['Colors']['Color_text']), 1.00, dxDraw['Font'][3], 'right', 'center', false, false, false, false, false)
				dxDrawText(j['Lider'], (screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 195 * scale, ((screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 ) + (38 + 10 + 5) * scale * lines - 37 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] + 180 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale, createColor(Config['Colors']['Color_text']), 1.00, dxDraw['Font'][3], 'center', 'center', false, false, false, false, false)
			end	
		end
	end
end


local currentX = (screen[1] - dxDraw['Sizes']['Rectangle_bar']['width']) / 2 - 190 * scale
local currentY = (screen[2] - dxDraw['Sizes']['Rectangle_bar']['height']) / 2 + 85 * scale

function updateMovbar()
    local elapsedTime = getTickCount() - Global_C['Var']['transitionStartTime']
    local progress = elapsedTime / Global_C['Var']['transitionDuration']

    if progress > 1 then 
        progress = 1 
    end

    local initialX = (screen[1] - dxDraw['Sizes']['Rectangle_bar']['width']) / 2 - 190 * scale
    local initialY = (screen[2] - dxDraw['Sizes']['Rectangle_bar']['height']) / 2 + 20 * scale
    local targetX, targetY

    for i, tab in ipairs(Global_C['tabData']) do
        if tab == Global_C['Var']['Window'] then
            targetX = initialX 
            targetY = initialY + (50 + 10 + 5) * i * scale
        end
    end


    currentX = currentX + progress * (targetX - currentX)
    currentY = currentY + progress * (targetY - currentY)
     
    dxDrawBordRectangle(currentX,currentY,dxDraw['Sizes']['Rectangle_mov']['width'],dxDraw['Sizes']['Rectangle_mov']['height'],4,createColor(Config['Colors']['Color_all']),false)

   --outputDebugString('Posição atual do retângulo: X=' ..'currentX .. ', Y=' .. currentY)
end

addEvent('AN >> OpenPanel', true)
addEventHandler('AN >> OpenPanel', root, function(typePanel2)
    if not Global_C['Var']['Visible'] then

        Global_C['Var']['Visible'] = true
        Global_C['Var']['Route'] = {0, 1}
        Global_C['Var']['Tick'] = getTickCount ()
        Global_C['Var']['Window'] = 'Inicial'
        Global_C['Var']['transitionStartTime'] = getTickCount()
        Global_C['Var']['typePanel'] = typePanel2

        triggerServerEvent('AN >> Information', localPlayer, typePanel2)
        showCursor(true)
        addEventHandler('onClientRender', root, Groups)
    else
		local currentX = 0
		local currentY = 0
        Global_C['Var']['Visible'] = false
        Global_C['Var']['Route'] = {1, 0}
        Global_C['Var']['Tick'] = getTickCount()
        Global_C['Var']['Window'] = nil
        Global_C['Var']['Select'] = 0

        setTimer (function ( )
        Global_C['Var']['Tick'] = nil
        showCursor(false)
        removeEventHandler('onClientRender', root, Groups)
        end, 500, 1)
    end
end)


addEventHandler('onClientClick', root, function (button, state)
    if Global_C['Var']['Visible'] then
        if button == 'left' and state == 'down' then
            for i, tab in ipairs(Global_C['tabData']) do
                if isCursorOnElement( (screen[1] - dxDraw['Sizes']['Rectangle_bar']['width']) / 2 - 180 * scale, ((screen[2] - dxDraw['Sizes']['Rectangle_bar']['height']) / 2) + (50 + 10 + 5) * i * scale, dxDraw['Sizes']['text_bar']['width'], dxDraw['Sizes']['text_bar']['height']) then
                    if Global_C['Var']['Window'] ~= tab then
                        Global_C['Var']['Window'] = tab
                        Global_C['Var']['transitionStartTime'] = getTickCount()
                    end
                end
            end
            lines = 0
            for k, j in ipairs(Global_C['Var']['resultTable'] or { }) do
                if k > (scrollData['Scroll_info:Offset'] or 0) and lines < (Global_C['Var']['maxLines'] or 0) then
                    lines = lines + 1
                    if isCursorOnElement((screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 205 * scale, ((screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 ) + (38 + 10 + 5) * scale * lines - 37 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] + 180 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale) then
                        Global_C['Var']['Select'] = k
                    end
                end
            end
            if Global_C['Var']['resultTable'][Global_C['Var']['Select']]  then
                if isCursorOnElement((screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 205 * scale, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 + 445 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] - 10 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale) then
                    local account = Global_C['Var']['resultTable'][Global_C['Var']['Select']]['Account']
                    local typePanel = Global_C['Var']['typePanel']
                    triggerServerEvent('AN >> Demitir', localPlayer, localPlayer, account, typePanel)
                    Global_C['Var']['Select'] = 0 
                elseif isCursorOnElement((screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 398 * scale, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 + 445 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] - 10 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 450 * scale) then
                    local account = Global_C['Var']['resultTable'][Global_C['Var']['Select']]['Account']
                    local typePanel = Global_C['Var']['typePanel']
                    triggerServerEvent('AN >> Lider', localPlayer, localPlayer, account, typePanel)
                    Global_C['Var']['Select'] = 0 
                end
            end
        end
    end
end)


addEvent('AN >> Dados', true)
addEventHandler('AN >> Dados', root, function(tablee)
    Global_C['Var']['resultTable'] = tablee
end)

addEvent('AN >> onDatabaseUpdated', true)
addEventHandler('AN >> onDatabaseUpdated', root, function()
    updatePanelData()
end)

function updatePanelData()
    if not Global_C['Var']['Visible'] then
        return
    end
    triggerServerEvent('AN >> Information', localPlayer, Global_C['Var']['typePanel'])
end
addEventHandler('onClientResourceStart', resourceRoot, updatePanelData)


function createColor(colorTable, alpha)
    local alpha = interpolateBetween(Global_C['Var']['Route'][1], 0, 0, Global_C['Var']['Route'][2], 0, 0, (getTickCount() - Global_C['Var']['Tick']) / 500, 'Linear')
    return tocolor(colorTable[1], colorTable[2], colorTable[3], (alpha * 255))
end

bindKey('i', 'down', function() 
	triggerServerEvent('AN >> BindKey', localPlayer, localPlayerp)
end)

function dxDrawScrollBar(key, sx, sy, w, h, visibleItems, currentItems, alpha)
    if Global_C['Var']['Visible'] then
        --if (not scrollData) then
        --    scrollData = {}
        --end

        if (not scrollData[key .. ':Offset']) then
            scrollData[key .. ':Offset'] = 0
        end

        local gripHeight = (h / currentItems) * visibleItems

        local gripY = sy + (h / currentItems) * math.min(scrollData[key .. ':Offset'], currentItems - visibleItems)

        if (getKeyState('mouse1')) then
            if (isCursorOnElement(sx, sy, w, h)) then 
                activeScroll = key
            end
        else
            activeScroll = false
        end

        if (activeScroll == key) then
            local _, cursorY = getCursorPosition()
            local cursorY = cursorY * screen[2]

            if (cursorY <= sy) then
                scrollData[key .. ':Offset'] = 0
            elseif (cursorY >= (sy + h)) then
                scrollData[key .. ':Offset'] = currentItems - visibleItems
            else
                scrollData[key .. ':Offset'] = math.floor((currentItems - visibleItems) / h * (cursorY - sy))
            end
        end

        if (gripY < sy) then
            gripY = sy
        elseif (gripY > (sy + h - gripHeight)) then
            gripY = sy + h - gripHeight
        end

        dxDrawBordRectangle(sx, sy, w, h, 5, createColor(Config['Colors']['Color_grid']), true)
        dxDrawBordRectangle(sx, gripY, w, gripHeight, 5, (isCursorOnElement(sx, gripY, w, gripHeight) or activeScroll == key) and createColor(Config['Colors']['Color_all']) or createColor(Config['Colors']['Color_all']), true)
    end
end


addEventHandler('onClientKey', root, function (key, press)
    if Global_C['Var']['Visible'] then
        if isCursorOnElement((screen[1] - dxDraw['Sizes']['Rectangle']['width']) / 2 + 205 * scale, (screen[2] - dxDraw['Sizes']['Rectangle']['height']) / 2 + 10 * scale, dxDraw['Sizes']['Rectangle_bar']['width'] + 180 * scale, dxDraw['Sizes']['Rectangle_bar']['height'] - 68 * scale) then
            if press and key == 'mouse_wheel_down' then
                scrollData['Scroll_info:Offset'] = scrollData['Scroll_info:Offset'] + 1
                if (scrollData['Scroll_info:Offset'] > #Global_C['Var']['resultTable'] - Global_C['Var']['maxLines']) then
                    scrollData['Scroll_info:Offset'] = #Global_C['Var']['resultTable'] - Global_C['Var']['maxLines']
                end
                elseif press and key == 'mouse_wheel_up' then
                if (scrollData['Scroll_info:Offset'] > 0) then
                    scrollData['Scroll_info:Offset'] = scrollData['Scroll_info:Offset'] - 1
                end
            end
        end
    end
end)