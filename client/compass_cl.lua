showing = true

CreateThread(
	function()
		local heading, lastHeading = 0, 1

		while true do
			Wait(0)

			if Config.compass.followGameplayCam then
				-- Converts [-180, 180] to [0, 360] where E = 90 and W = 270
				local camRot = GetGameplayCamRot(0)
				heading = tostring(round(360.0 - ((camRot.z + 360.0) % 360.0)))
			else
				-- Converts E = 270 to E = 90
				heading = tostring(round(360.0 - GetEntityHeading(cache.ped)))
			end
			if heading == "360" then
				heading = "0"
			end
			if heading ~= lastHeading then
				if showing then
					SendNUIMessage({action = "display", value = heading})
				end
				Wait(2)
			end
			lastHeading = heading
		end
	end
)

exports(
	"getStreet",
	function()
		local playerPos = GetEntityCoords(cache.ped, true)
		local streetA, streetB = GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
		street = {}

		if not ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
			lastStreetA = streetA
			lastStreetB = streetB
		end

		if lastStreetA ~= 0 then
			--table.insert(street, GetStreetNameFromHashKey(lastStreetA))
			street[#street + 1] = GetStreetNameFromHashKey(lastStreetA)
		end

		if lastStreetB ~= 0 then
			--table.insert(street, GetStreetNameFromHashKey(lastStreetB))
			street[#street + 1] = GetStreetNameFromHashKey(lastStreetB)
		end

		street = table.concat(street, " & ")

		return street
	end
)

CreateThread(
	function()
		local lastStreetA = 0
		local lastStreetB = 0

		while true do
			Wait(0)

			local playerPos = GetEntityCoords(cache.ped, true)
			local streetA, streetB = GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
			street = {}

			if not ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
				lastStreetA = streetA
				lastStreetB = streetB
			end

			if lastStreetA ~= 0 then
				street[#street + 1] = GetStreetNameFromHashKey(lastStreetA)
			end

			if lastStreetB ~= 0 then
				street[#street + 1] = GetStreetNameFromHashKey(lastStreetB)
			end

			myPostal = exports["PriorityHUD"].getPostal()
			street = myPostal .. " " .. table.concat(street, " & ")

			if street ~= laststreet then
				if showing then
					SendNUIMessage({action = "display", type = street})
				end
				Wait(100)
			end

			laststreet = street
			Wait(100)
		end
	end
)

RegisterNetEvent(
	"txcl:showAnnouncement",
	function()
		if showing then
			showing = false
			SendNUIMessage({action = "hide"})
			Wait(9000)
			showing = true
			local camRot = GetGameplayCamRot(0)
			heading = tostring(round(360.0 - ((camRot.z + 360.0) % 360.0)))
			if heading == "360" then
				heading = "0"
			end
			if heading ~= lastHeading then
				SendNUIMessage({action = "display", value = heading})
			end
		end
	end
)

RegisterNetEvent(
	"Grave:HUD:Hide",
	function()
		if showing then
			showing = not showing
			SendNUIMessage({action = "hide"})
		else
			showing = not showing
			local camRot = GetGameplayCamRot(0)
			heading = tostring(round(360.0 - ((camRot.z + 360.0) % 360.0)))
			if heading == "360" then
				heading = "0"
			end
			if heading ~= lastHeading then
				SendNUIMessage({action = "display", value = heading})
			end
		end
	end
)
