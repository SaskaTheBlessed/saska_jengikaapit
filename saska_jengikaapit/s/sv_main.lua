local rob = false 

ESX = nil																																																										
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)                                                                                                                                                                   
RegisterServerEvent('blessed_asekaappi:toofar')                                                                                                                                                                                       
AddEventHandler('blessed_asekaappi:toofar', function(jengi)                                                                                                                                                                           
	local source = source                                                                                                                                                                                                          
	local xPlayers = ESX.GetPlayers()                                                                                                                                                                                              
	rob = false                                                                                                                                                                                                                    
	for i=1, #xPlayers, 1 do                                                                                                                                                                                                       
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])                                                                                                                                                                           
 		if xPlayer.job.name == jengi then                                                                                                                                                                                          
			TriggerClientEvent('saska_jengikaappi', xPlayers[i], 'Kaappia ei saatu murrettua')                                                                                                                                               
			TriggerClientEvent('blessed_asekaappi:killblip', xPlayers[i])                                                                                                                                                             
		end                                                                                                                                                                                                                        
	end                                                                                                                                                                                                                            
	TriggerClientEvent('blessed_asekaappi:toofarlocal', source)                                                                                                                                                                       
end)
																							

			
RegisterServerEvent('blessed_asekaappi:rob')                                                                                                                                                                                          
AddEventHandler('blessed_asekaappi:rob', function(robb)                                                                                                                                                                               
	local source = source                                                                                                                                                                                                          
	local xPlayer = ESX.GetPlayerFromId(source)                                                                                                                                                                                    
	local xPlayers = ESX.GetPlayers()                                                                                                                                                                                              
	local cops = 0                                                                                                                                                                                                                 
	local jenggilaisia = 0                                                                                                                                                                                                         
	for i=1, #xPlayers, 1 do                                                                                                                                                                                                       
 	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])                                                                                                                                                                               
		if xPlayer.job.name == 'police' then                                                                                                                                                                                       
			cops = cops + 1                                                                                                                                                                                                        
		elseif xPlayer.job.name == robb then                                                                                                                                                                                       
			jenggilaisia = jenggilaisia+1                                                                                                                                                                                          
		end                                                                                                                                                                                                                        
	end   

	if Kaapit[robb] then
		local kaappi = Kaapit[robb]

		if (os.time() - kaappi.lastRobbed) < 1800 and kaappi.lastRobbed ~= 0 then
                        TriggerClientEvent('esx:showNotification', source, '~r~Kaappi on jo ryöstetty! Odota n. ~b~30min')
			return
		end

                                                                                                                                                                                                                         
	if not rob then		                                                                                                                                                                                                           
		if(cops >= 0)then                                                                                                                                                                                
			if(jenggilaisia >= 2)then                                                                                                                                                                      
				rob = true                                                                                                                                                                                                         
				for i=1, #xPlayers, 1 do                                                                                                                                                                                           
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])                                                                                                                                                               
					if xPlayer.job.name == robb then                                                                                                                                                                               
							TriggerClientEvent('saska_jengikaappi', xPlayers[i], '~r~Kaappiasi ryöstetään!')                                                                                                          
							TriggerClientEvent('blessed_asekaappi:setblip', xPlayers[i], Kaapit[robb].position)                                                                                                                        
					end                                                                                                                                                                                                            
				end                                                                                                                                                                                                                
				TriggerClientEvent('saska_jengikaappi', source, 'Aloitit ryöstön!')                                                                                                                                                 
				TriggerClientEvent('saska_jengikaappi', source, '~r~Älä liiku yli metriä kauemmas!')                                                                                                                                
				TriggerClientEvent('blessed_asekaappi:starttimer', source)                                                                                                                                                            
				TriggerClientEvent('blessed_asekaappi:currentlyrobbing', source, robb)    
				Kaapit[robb].lastRobbed = os.time()
                                                                                                                                            
				SetTimeout(300000, function()                                                                                                                                                                                       
						if rob then                                                                                                                                                                                                
									local awardi = math.random(10000,20000)                                                                                                                                                        
									TriggerClientEvent('blessed_asekaappi:robberycomplete', source,awardi)                                                                                                                            
									rob = false                                                                                                                                                                                    
									local xPlayer = ESX.GetPlayerFromId(source)	                                                                                                                                                   
									MySQL.Async.fetchAll("SELECT * FROM `addon_account_data`",                                                                                                                                     
									{},                                                                                                                                                                                            
									function(result)                                                                                                                                                                               
										for i=1, #result do                                                                                                                                                                        
											if result[i].account_name == "society_"..robb then                                                                                                                                     
												local uusmoney = result[i].money - awardi                                                                                                                                          
												MySQL.Async.execute("UPDATE addon_account_data SET `money` = @money WHERE account_name = @account_name LIMIT 1",{["@account_name"] = "society_"..robb,["@money"] = uusmoney})      
											end                                                                                                                                                                                    
										end								                                                                                                                                                           
									end)                                                                                                                                                                                           
									xPlayer.addMoney(awardi)                                                                                                                                                                       
						end						                                                                                                                                                                                   
						if(xPlayer)then                                                                                                                                                                                            
							local xPlayers = ESX.GetPlayers()                                                                                                                                                                      
							for i=1, #xPlayers, 1 do                                                                                                                                                                               
								local xPlayer = ESX.GetPlayerFromId(xPlayers[i])                                                                                                                                                   
								if xPlayer.job.name == robb then                                                                                                                                                                   
										TriggerClientEvent('saska_jengikaappi', xPlayers[i], 'Kaappia ei saatu murrettua')                                                                                           
										TriggerClientEvent('blessed_asekaappi:killblip', xPlayers[i])                                                                                                                                 
								end                                                                                                                                                                                                
							end                                                                                                                                                                                                    
						end                                                                                                                                                                                                        
				end)                                                                                                                                                                                                               
			else                                                                                                                                                                                                                   
				TriggerClientEvent('saska_jengikaappi', source, 'Kaupungissa ei ole vähintään ~r~2 kassakaapin omistajaa~s~ paikalla.')                                                                
			end                                                                                                                                                                                                                    
		else                                                                                                                                                                                                                       
			TriggerClientEvent('saska_jengikaappi', source, 'Kaupungissa ei ole vähintään ~b~1 poliisia ')                                                                                          
		end                                                                                                                                                                                                                        
	else                                                                                                                                                                                                                           
		TriggerClientEvent('saska_jengikaappi', source, '~r~Joku perkele ryöstellyt jo kassakaappeja! Odota jonkin aikaa.')                                                                                                         
	end  
    end                                                                                                                                                                                                                          
end)																																																							