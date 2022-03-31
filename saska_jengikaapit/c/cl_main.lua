local holdingup = false
local store = ""
local blipRobbery = nil
ESX = nil
local blessed = false
local PlayerData = {}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	PlayerData = ESX.GetPlayerData()
end)

local function _ts(num)
	if num == 0 or not num then 
		return nil
	end
	return tostring(num)
end

RegisterNetEvent('saska_jengikaappi')
AddEventHandler('saska_jengikaappi', function(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, false)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.6, 0.6)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 150)
	SetTextDropshadow()
	SetTextOutline()
	 SetTextEntry("STRING")
	 AddTextComponentString(text)
	 DrawText(x - width/2, y - height/2 + 0.005)
 
 end

RegisterNetEvent('blessed_asekaappi:currentlyrobbing')
AddEventHandler('blessed_asekaappi:currentlyrobbing', function(robb)
	holdingup = true
	kaappi = robb
end)

RegisterNetEvent('blessed_asekaappi:killblip')
AddEventHandler('blessed_asekaappi:killblip', function()
	RemoveBlip(blipRobbery)
end)

RegisterNetEvent('blessed_asekaappi:setblip')
AddEventHandler('blessed_asekaappi:setblip', function(position)
	blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery, 487)
	SetBlipScale(blipRobbery, 2.0)
	SetBlipDisplay(blipRobbery, 4)
	SetBlipColour(blipRobbery, 0)
	SetBlipFlashes(blipRobbery, true)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(('Kassakaapin ryöstö'))
    EndTextCommandSetBlipName(blipRobbery)
end)

RegisterNetEvent('blessed_asekaappi:toofarlocal')
AddEventHandler('blessed_asekaappi:toofarlocal', function()
	holdingup = false
	TriggerEvent("saska_jengikaappi",'Ryöstö keskeytyi!')
	incircle = false
end)


RegisterNetEvent('blessed_asekaappi:robberycomplete')
AddEventHandler('blessed_asekaappi:robberycomplete', function(award)
	holdingup = false
	TriggerEvent("saska_jengikaappi",'~r~Ryöstö onnistui~s~, sinä ~b~varastit~s~ ~g~$'..award)
	kaappi = ""
	incircle = false
end)


RegisterNetEvent('blessed_asekaappi:starttimer')
AddEventHandler('blessed_asekaappi:starttimer', function()
	timer = 300
	Citizen.CreateThread(function()
		while timer > 0 do

			Citizen.Wait(1000)
			if timer > 0 then
				timer = timer - 1
			end
		end
	end)
	blessed = true
	Citizen.CreateThread(function()
		while blessed do
			Citizen.Wait(0)
			if holdingup then
				--drawTxt(0.66, 1.4, 1.0,1.0,0.4, 'Kassakaapin ryöstö: ~r~'..timer..'~s~ sekunttia jäljellä', 255, 255, 255, 255)
				drawTxt(0.66, 1.44, 1.0,1.0,0.4, 'Kassakaapin ryöstö: ~r~'..timer..'~s~ sekunttia jäljellä', 255, 255, 255, 255)

			else
				blessed = false
			end
		end
	end)
end)


incircle = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(PlayerPedId(), true)

		for k,v in pairs(Kaapit)do
			local pos2 = v.position

			if Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0 then
				if not holdingup then

					if Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0 then
						if not incircle then
							Citizen.InvokeNative(0x8509B634FBE7DA11, _ts('STRING'))
							Citizen.InvokeNative(0x6C188BE134E074AA, _ts('paina ~INPUT_CONTEXT~ ~r~tyhjentääksesi~s~ kassakaapin'))
							Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)
						end

						incircle = true
						if IsControlJustReleased(0, 38) then
							if IsPedArmed(PlayerPedId(), 7) then
								if PlayerData.job.name ~= k then
									TriggerServerEvent('blessed_asekaappi:rob', k)
								else
									TriggerEvent("saska_jengikaappi",'~r~Idiootti! ~w~Etkai sä nyt omaa kassakaappia ryöstä!')
								end
							else
								TriggerEvent("saska_jengikaappi",'~r~????! ~w~Tarvitset kättä pidempää!')
							end
						end

					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
						incircle = false
					end
				end
			end
		end

		if holdingup then

			local pos2 = Kaapit[kaappi].position
			if Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 4 then
				TriggerServerEvent('blessed_asekaappi:toofar', kaappi)
			end
			
			if IsPedDeadOrDying(GetPlayerPed(-1)) then
				TriggerServerEvent('blessed_asekaappi:toofar', kaappi)
			end
		end
		
	end
end)
