--[[
 █▀▀█ █▄░▒█ █▀▀▄ █▀▀█ █▀▀▀ █░░▒█  
 █▄▄█ █▒█▒█ █░▒█ █▄▄▀ █▀▀▀ █▄▄▄█  
 █░▒█ █░░▀█ █▄▄▀ █░▒█ █▄▄▄ ░▒█░░  
]]

Config = {

    ['General'] = {
        ['TimerBlack'] = 60; --- Tempo em segundos 86400 = 1 dia de blacklist.  
    };

    ['Colors'] = { 
        ['Color_bg'] = {28,28,28};
        ['Color_bar'] = {31, 31, 31 };
        ['Color_all'] = {131,111,255};
        ['Color_grid'] = {35,35,35};
        ['Color_text'] = {255, 255, 255};
        ['Button_color'] = {131,111,255};
        ['Button_color2'] = {250, 68, 84};
    };

    ['Groups_Name'] = {
        ['Los_Blancos'] = {
            {Group = 'Los_Blancos', Name = 'Los Blancos', Limit = 2}
        };
        ['Policia'] = {
            {Group = 'Policia', Name = 'Policia', Limit = 10}
        };
        ['Turquia'] = {
            {Group = 'Turquia', Name = 'Turquia', Limit = 10}
        };
    };
}


Info_box = {
    Info_C = function(self, msg, type)
        exports['hz_info']:showBoxS(msg, self.types[type])
    end;

    Info_S = function(self, player, msg, type)
            exports['hz_info']:showBoxS(player, msg, self.types[type])
        end;    

    types = {
        ['erro'] = 'error'; 
        ['info'] = 'info';
        ['sucess'] = 'sucess';
    };
}


 