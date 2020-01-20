local myHorse = {0, 0, 0, 0}
local playerPed = PlayerPedId()

RegisterCommand('spawnhorse', function(source, args, rawCommand)

	checkHorse()
    
end)

RegisterCommand('flee', function(source, args, rawCommand)
	fleeHorse()
    
end)

RegisterCommand('dh', function(source, args, rawCommand)

	delHorse()
    
end)

RegisterCommand('reghorse', function(source, args, rawCommand)
	local isMounted = IsPedOnMount(playerPed)
	if args[1] ~=nil and isMounted then
		newVeh('horse', args[1])
	elseif isMounted then
		newVeh('horse')
	else
		print('Not mounted!')
	end
    
end)

RegisterCommand('defaulthorse', function(source, args, rawCommand)

	defHorse(args[1])
    
end)

RegisterNetEvent('z00thorses:spawnHorse')
AddEventHandler('z00thorses:spawnHorse', function(horseData, horseName, id)
  myHorse[1] = tonumber(horseData)
  myHorse[2] = id
  myHorse[3] = horseName
  print("Model: ", myHorse[1], " DB ID: ", myHorse[2])
  if myHorse[1] ~= 0 then
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0.0, -40.0, 0.3))
	local a,b = GetGroundZAndNormalFor_3dCoord(x, y, z)
print"wtf 1"

    
	Citizen.CreateThread(function()
        local waiting = 0
		print"wtf 3"
        while not HasModelLoaded(tonumber(horseData)) do
			RequestModel(tonumber(horseData),true)
            waiting = waiting + 1
            Citizen.Wait(100)
			print"wtf 2"
            if waiting > 5000 then
                print("Could not load ped")
                break
            end
        end
		print"wtf 4"
		cds = GetOffsetFromEntityInWorldCoords(playerPed,0.0,2.0,0.0)
            myHorse[4] = CreatePed(tonumber(horseData),cds.x,cds.y,cds.z,GetEntityHeading(playerPed)-180, 1, 1)
			Citizen.InvokeNative(0x6A071245EB0D1882, myHorse[4], playerPed, -1, 7.2, 2.0, 0, 0)
			--Citizen.InvokeNative(0x283978A15512B2FE, myHorse[4], true) -- blip function keeps failing 
			Citizen.InvokeNative(0x58A850EAEE20FAA3, myHorse[4])
				SetPedOutfitPreset(myHorse[4],12,0)
			
			SetPedNameDebug(myHorse[4], myHorse[3])
			SetPedPromptName(myHorse[4], myHorse[3])
			Citizen.InvokeNative( 0x9FF1E042FA597187, myHorse[4], 200, true )
			SetModelAsNoLongerNeeded(myHorse[4])
			Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),0x67AF7302,true,true,true) --stirups
			Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),0x20359E53,true,true,true)

			
    end)
  end
end)

function checkHorse(source, args, rawCommand)
print"check1 "
	local isMounted = IsPedOnMount(playerPed)
	playerPed = PlayerPedId() --Updating when needed?
	if myHorse[4] ~= 0 then
		if not isMounted then
		print"check2 "
			Citizen.InvokeNative(0x6A071245EB0D1882, myHorse[4], playerPed, -1, 7.2, 2.0, 0, 0)
		end
	else
	print"check3 "
		TriggerServerEvent("z00thorses:getHorse")
	end
end

function Runaway()
print"runf"
Citizen.CreateThread(function()
	hash = GetHashKey("p_wrappedmeat01x")
		while not HasModelLoaded(hash) do
		Citizen.Wait(1000)
		if not HasModelLoaded(hash) then
		        Citizen.InvokeNative(0xFA28FE3A6246FC30,tonumber(hash),true)
				end

			
		end
ran = math.random(1,4)
if ran == 1 then
ran = -100.0
else
ran = 100.0
end
cds = GetOffsetFromEntityInWorldCoords(playerPed,0.0,ran,0.0)

ent = CreateObject(hash,cds, false, false, false) 
	Wait(200)
Citizen.InvokeNative(0x6A071245EB0D1882, myHorse[4], ent, -1, 7.2, 2.0, 0, 0)

	Wait(15000)
	SetEntityAsMissionEntity(myHorse[4],true,true)
	DeleteEntity(ent)
	print"del horse"
		DeletePed(myHorse[4])
		DeleteEntity(myHorse[4])
		DeleteObject(myHorse[4])





end)
end

local interiorsActive = false



function fleeHorse(source, args, rawCommand)

	if myHorse[4] ~= 0 then
Runaway()	
Wait(15000)
		DeletePed(myHorse[4])
		DeleteEntity(myHorse[4])
		DeleteObject(myHorse[4])
		TriggerServerEvent("z00thorses:stableHorse", myHorse[2])
		myHorse[4] = 0
	end
    
end

function newVeh(vehType, id)
	print(vehType, id)
	local currentHorse = GetEntityModel(GetMount(playerPed))
	local inPut1 = ""
	local inPut2 = ""
	Citizen.CreateThread(function()
		AddTextEntry('FMMC_MPM_NA', "Name your horse:")
		DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "Name", "", "", "", 30)
		while (UpdateOnscreenKeyboard() == 0) do
			DisableAllControlActions(0);
			Citizen.Wait(0);
		end
		if (GetOnscreenKeyboardResult()) then
			inPut1 = GetOnscreenKeyboardResult()
			print('Horse Hash?', currentHorse, inPut1)
	TriggerServerEvent('z00thorses:newVehicle', currentHorse, vehType, inPut1, id)
		end
	
	end)

end

function delHorse(source, args, rawCommand)

	if myHorse[4] ~= 0 then
		DeletePed(myHorse[4])
		TriggerServerEvent("z00thorses:stableHorse", myHorse[2])
		myHorse[4] = 0
	end
    
end

function defHorse(name)

	TriggerServerEvent("z00thorses:defVeh", name)
	
end

Citizen.CreateThread(function()
    while true do
		
        Citizen.Wait(0)
        --DisableControlAction(0,0x24978A28,true)
        if IsControlJustPressed(0, 0x24978A28) then -- Control =  H
			checkHorse()
			Citizen.Wait(2000) --Flood Protection?
        end
		
		if Citizen.InvokeNative(0x91AEF906BCA88877, 0, 0x4216AF06) then -- Control = Horse Flee
			local horseCheck = Citizen.InvokeNative(0x7912F7FC4F6264B6, playerPed, myHorse[4])
			if horseCheck then
			
				fleeHorse()
			end
		end			
		
    end
end)
