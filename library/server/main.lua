--[[
 █▀▀█ █▄░▒█ █▀▀▄ █▀▀█ █▀▀▀ █░░▒█  
 █▄▄█ █▒█▒█ █░▒█ █▄▄▀ █▀▀▀ █▄▄▄█  
 █░▒█ █░░▀█ █▄▄▀ █░▒█ █▄▄▄ ░▒█░░  
]]

local database = dbConnect ('sqlite', 'library/assets/database/dados.sql')

addEventHandler('onResourceStart', getRootElement(), function(res)
    if res == getThisResource() then
    	for groupData, tabelaName in pairs(Config['Groups_Name']) do
	        if (database) then
	            dbExec(database, 'CREATE TABLE IF NOT EXISTS '..groupData..' (Conta, Nome, ID, Lider, Logs, DataOnline)')
	            dbExec(database, 'CREATE TABLE IF NOT EXISTS Blacklist (Conta, State, Hora, Acaba)')
	            print('Banco de dados conectado com sucesso!')
	        else
	            error('Banco de dados não foi inicializado corretamente!', 1)
	        end
	        dbExec (database, 'UPDATE Blacklist SET State = ? WHERE State = ?', 'Blacklist')
	    end
	end
end)

addEvent('AN >> BindKey', true)
addEventHandler('AN >> BindKey', root,
function ()
    local account = getPlayerAccount(source)
    if account then 
        local accountName = getAccountName(account)
        for groupData, data in pairs(Config['Groups_Name']) do
            if veriTable(database, groupData) then
                local result = dbPoll(dbQuery(database, 'SELECT * FROM '..groupData ..' WHERE Conta = ?', accountName), -1)
                for _, dataResult in ipairs(result) do
                    if dataResult['Lider'] == 'Lider' then
                        if #result > 0 then
                            triggerClientEvent(client, 'AN >> OpenPanel', client, groupData)
                            return
                        end
                    else
                        Info_box:Info_S(source, 'Você NÃO é lider do grupo:' ..groupData, 'erro')
                    end
                end
            end
        end
    end
end)


addEvent('AN >> Information', true)
addEventHandler('AN >> Information', root, function (groupData)
    local Table_group = { }
    if veriTable(database, groupData) then
        local result = dbPoll(dbQuery(database, 'SELECT * FROM '..groupData ..''), -1)
        if #result > 0 then
            for _, data in ipairs(result) do
                --iprint(data)
                local info = {
                    Account = data['Conta'];
                    Lider = data['Lider'];
                    Logs = data['Logs'];
                    id = data['ID'];
                    Ultimavezonline = data['DataOnline']
                }
                --Table_group[data['Conta']] = info
                table.insert(Table_group, info)
                --return
            end
        end
        if (#Table_group > 0) then
            triggerClientEvent(client, 'AN >> Dados', resourceRoot, Table_group)
        else
            return false
        end
    end
end)

 
addCommandHandler('removleader', function(thePlayer, comando, account, TabelaName)
    if not (account and TabelaName) then
        Info_box:Info_S(thePlayer, 'Uso: /removleader <conta> <nome_grupo>', 'erro')
        return
    end
    local tabelaExistente = veriTable(database, TabelaName)    -- Verifica se a tabela existe no banco de dados
    if not Config['Groups_Name'][TabelaName] then  -- Verifica se a tabela existe
        Info_box:Info_S(thePlayer, 'O grupo não existe: ' .. TabelaName, 'erro')
        return
    end
    if not tabelaExistente then -- Verifica se a tabela existe no banco de dados
         Info_box:Info_S(thePlayer, 'O grupo não existe no banco de dados: ' .. TabelaName, 'erro')
        return
    end
    local result = dbPoll(dbQuery(database, 'SELECT * FROM '..TabelaName ..' WHERE Conta = ?', account), -1) -- Executa a consulta para verificar se o jogador está na tabela
    if result and #result > 0 then  -- Se o jogador estiver na tabela, remove-o
        local success, error = dbExec(database, 'DELETE FROM '..TabelaName..' WHERE Conta = ?', account)
        if success then
             Info_box:Info_S(thePlayer, 'Jogador foi removido do grupo: ' ..TabelaName, 'success')
            updateDatabase()
            addToBlacklist(account)
        else
             Info_box:Info_S(thePlayer, 'Erro ao remover jogador: ' .. error, 'erro')
        end
    else
        Info_box:Info_S(thePlayer, 'O jogador não está em um grupo: ' ..TabelaName, 'erro')
    end
end)



addCommandHandler('setleader', function(thePlayer, comando, account, TabelaName)
    if not (account and TabelaName) then
        Info_box:Info_S(thePlayer, 'Uso: /setleader <conta> <nome_grupo>', 'erro')
        return
    end
    
    local tabelaExistente = Config['Groups_Name'][TabelaName] and veriTable(database, TabelaName)
    
    if not tabelaExistente then
        Info_box:Info_S(thePlayer, 'O grupo não existe: ' .. TabelaName, 'erro')
        return
    end

    if isPlayerBlacklisted(account) then 
        Info_box:Info_S(thePlayer, 'O jogador '..account..' está na blacklist.', 'erro')
        return
    end

    for existingTable, _ in pairs(Config['Groups_Name']) do
        local resultt = dbPoll(dbQuery(database, 'SELECT * FROM '..existingTable..' WHERE Conta = ?', account), -1)
        if resultt and #resultt > 0 then
            Info_box:Info_S(thePlayer,'O jogador já está em um grupo. Não pode ser adicionado a outra.', 'erro')
            return
        end
    end

    local maxTableLimit = tonumber(Config['Groups_Name'][TabelaName][1]['Limit']) or 0 
    local countResult = dbPoll(dbQuery(database, 'SELECT COUNT(*) AS total FROM '..TabelaName), -1)
    local currentTableCount = tonumber(countResult and countResult[1] and countResult[1]['total']) or 0

    if currentTableCount >= maxTableLimit then
        Info_box:Info_S(thePlayer,'O grupo ' .. TabelaName .. ' atingiu o limite de ' .. maxTableLimit .. ' jogadores. Não pode adicionar mais jogadores.', 'erro')
        return
    end
    local result = dbPoll(dbQuery(database, 'SELECT * FROM '..TabelaName..' WHERE Conta = ?', account), -1)
    if result and #result == 0 then
        local success, error = dbExec(database, 'INSERT INTO ?? (Nome, Lider, Conta, ID, DataOnline) VALUES (?, ?, ?, ?, ?)', TabelaName, 'N/A', 'Lider', account, getElementData(thePlayer, 'ID') or 'N/A', 'Online', obterDataHora())
        
        if success then
            Info_box:Info_S(thePlayer, 'Jogador adicionado como lider do grupo: ' .. TabelaName, 'success')
            updateDatabase()
        else
            Info_box:Info_S(thePlayer, 'Erro ao adicionar jogador: ' .. error, 'erro')
        end
    else
        Info_box:Info_S(thePlayer, 'O jogador já está na tabela ' .. TabelaName, 'erro')
    end
end)



addEvent('AN >> Demitir', true)
addEventHandler('AN >> Demitir', root, function(thePlayer, AccountSelect, TabelaName)
    local accountName = getAccountName(getPlayerAccount(thePlayer))

    local result = dbPoll(dbQuery(database, 'SELECT * FROM '..TabelaName ..' WHERE Conta = ?', AccountSelect), -1)

    if result and #result > 0 then
        local dataResult = result[1]  

        if dataResult['Lider'] == 'Lider' and accountName == AccountSelect then
            Info_box:Info_S(thePlayer, 'Você não pode demitir a si mesmo do grupo: ' ..TabelaName, 'erro')
        elseif dataResult['Lider'] == 'Lider' then
            Info_box:Info_S(thePlayer, 'Você não pode demitir outro líder do grupo: ' ..TabelaName, 'erro')
        else
            local success, error = dbExec(database, 'DELETE FROM '..TabelaName..' WHERE Conta = ?', AccountSelect)
            if success then
                Info_box:Info_S(thePlayer, 'Jogador foi removido do grupo: ' ..TabelaName, 'success')
                updateDatabase()
                addToBlacklist(account)
            else
                Info_box:Info_S(thePlayer, 'Erro ao remover jogador: ' .. error, 'erro')
            end
        end
    else
        Info_box:Info_S(thePlayer, 'O jogador não está em um grupo: ' ..TabelaName, 'erro')
    end
end)



addEvent('AN >> Lider', true)
addEventHandler('AN >> Lider', root, function(thePlayer, AccountSelect, TabelaName)
    local result = dbPoll(dbQuery(database, 'SELECT * FROM '..TabelaName..' WHERE Conta = ?', AccountSelect), -1)
    if result and #result > 0 then
        local isAlreadyLeader = result[1]['Lider'] == 'Lider'
        if not isAlreadyLeader then
            local success, error = dbExec(database, 'UPDATE ?? SET Lider = ? WHERE Conta = ?', TabelaName, 'Lider', AccountSelect)
            if success then
                Info_box:Info_S(thePlayer, 'Jogador atualizado no grupo: ' .. TabelaName, 'success')
                updateDatabase()
            else
                Info_box:Info_S(thePlayer, 'Erro ao atualizar jogador: ' .. error, 'erro')
            end
        else
            Info_box:Info_S(thePlayer, 'O jogador já é líder no grupo: ' .. TabelaName, 'erro')
        end
    else
        Info_box:Info_S(thePlayer, 'O jogador não está no grupo: ' .. TabelaName, 'erro')
    end
end)



function addToBlacklist(accountName)
    local tempoAtual = getRealTime().timestamp
    local tempoLimite = tempoAtual + Config['General']['TimerBlack']

    if accountName then 
        dbExec(database, 'INSERT INTO Blacklist (Conta, State, Hora, Acaba) VALUES (?, ?, ?, ?)', accountName, 'Blacklist', tempoAtual, tempoLimite)
    end
end


function isPlayerBlacklisted(accountName)
    if accountName then
        local tempoAtual = getRealTime().timestamp
        local result = dbPoll(dbQuery(database, 'SELECT * FROM Blacklist WHERE Conta = ?', accountName), -1)

        if result and #result > 0 then
            local tempoAcaba = tonumber(result[1]['Acaba'])
            if tempoAcaba and tempoAtual < tempoAcaba then
                return true, tempoAcaba - tempoAtual
            else
                dbExec(database, 'DELETE FROM Blacklist WHERE Conta = ?', accountName)
            end
        end

        return false, 0
    end
end


addEventHandler('onPlayerQuit', root, function(quitType, reason, responsibleElement)
    local dataHoraSaida = obterDataHora()
    local account = getAccountName(getPlayerAccount(source))
    for TabelaName, data in pairs(Config['Groups_Name']) do
        local result = dbPoll(dbQuery(database, 'SELECT * FROM '..TabelaName..' WHERE Conta = ?', account), -1)
        if result and #result > 0 then
            dbExec(database, 'UPDATE ?? SET DataOnline = ? WHERE Conta = ?', TabelaName, dataHoraSaida, account)
        end
    end
    updateDatabase()
end)


addEventHandler('onPlayerLogin', root, function(_, account)
    if account then
        local accountName = getAccountName(getPlayerAccount(source))
        for TabelaName, data in pairs(Config['Groups_Name']) do
            local result = dbPoll(dbQuery(database, 'SELECT * FROM '..TabelaName..' WHERE Conta = ?', accountName), -1)
            if result and #result > 0 then
                dbExec(database, 'UPDATE ?? SET DataOnline = ? WHERE Conta = ?', TabelaName, 'Online', accountName)
            end
        end
        updateDatabase()
    end
end)



function updateDatabase()
    triggerClientEvent('AN >> onDatabaseUpdated', root)
end


function veriTable(database, tabelaDBName)
    local result = dbPoll(dbQuery(database, 'SELECT name FROM sqlite_master WHERE type="table" AND name=?', tabelaDBName), -1)
    if result and #result > 0 then
        return true  -- A tabela existe
    else
        return false  -- A tabela não existe
    end
end


function obterDataHora()
    local tempoReal = getRealTime()
    
    local dia = tempoReal.monthday
    local mes = tempoReal.month + 1  
    local ano = tempoReal.year + 1900 

    local hora = tempoReal.hour
    local minuto = tempoReal.minute

    local dataHoraFormatada = string.format("%02d/%02d/%04d %02d:%02d", dia, mes, ano, hora, minuto)

    return dataHoraFormatada
end

function obterTempoRestante(tempoRestante)
    local segundosEmUmDia = 24 * 60 * 60
    local dias = math.floor(tempoRestante / segundosEmUmDia)
    local horas = math.floor((tempoRestante % segundosEmUmDia) / 3600)
    local minutos = math.floor((tempoRestante % 3600) / 60)
    local segundos = math.floor(tempoRestante % 60)

    local formatoDias = dias > 0 and string.format("%d dias, ", dias) or ""
    
    return formatoDias .. string.format("%02d:%02d:%02d", horas, minutos, segundos)
end


addCommandHandler('testee', function(thePlayer)
    local accountName = getAccountName(getPlayerAccount(thePlayer))
    local blacklisted, tempoRestante = isPlayerBlacklisted(accountName)
    if blacklisted then
        outputChatBox('Você está na blacklist. Tempo restante: ' .. obterTempoRestante(tempoRestante), source, 255, 0, 0)
    end
end)

