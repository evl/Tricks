evl_TricksDB = evl_TricksDB or {}

BINDING_HEADER_EVLTRICKS = "Evl's Tricks"

local frame = CreateFrame("Frame")
local targets = {"Primary", "Secondary", "Tertiary"}
local macroName = "Evl's Tricks"

local function generateMacro()
	if InCombatLockdown() then
		frame:RegisterEvent("PLAYER_REGEN_ENABLED")

		print(format("Tricks: In combat, macro will be updated after leaving combat."))
	else
		frame:UnregisterEvent("PLAYER_REGEN_ENABLED")
	
		local body = "#showtooltip Tricks of the Trade\n/cast "
	
		for _, target in pairs(targets) do
			local name = evl_TricksDB[target]

			if name then 
				body = body .. format("[@%s,nodead,nomod]", name)
			end
		end
	
		body = body .. "[@targettarget,help] Tricks of the Trade"

		local index = GetMacroIndexByName(macroName)

		if index > 0 then
			EditMacro(index, macroName, 1, body, true)
		else
			index = CreateMacro(macroName, 1, body, true)
			PickupMacro(index)

			print(format("Tricks: Created new macro '%s'", macroName))
		end
	end
end

frame:SetScript("OnEvent", generateMacro)

function EvlTricks_Set(type)
	local unit = "target"
	local previousName = evl_TricksDB[type]
	
	if not UnitExists(unit) then
		if previousName then
			evl_TricksDB[type] = nil
			generateMacro()

			print(format("Tricks: Cleared %s target (%s)", type:lower(), previousName))
		else
			print("Tricks: No target selected")
		end
	elseif not UnitInParty(unit) and not UnitInRaid(unit) then
		print("Tricks: Target must be a player in your party/raid")
	else
		local name = UnitName(unit)

		evl_TricksDB[type] = name
		generateMacro()
		
		SendChatMessage("You're getting my Tricks of the Trade!", "WHISPER", nil, name)
		
		print(format("Tricks: %s target is now %s", type, name))
	end
end
