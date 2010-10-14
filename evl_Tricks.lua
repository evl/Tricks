evl_TricksDB = evl_TricksDB or {}

local targets = {"Primary", "Secondary", "Tertiary"}
local macroName = "Evl's Tricks"

local function generateMacro()
	local body = "#showtooltip Tricks of the Trade\n/cast "
	
	for _, target in pairs(targets) do
		local name = evl_TricksDB[target]

		if name then 
			body = body .. format("[@%s,nodead,nomod]", name)
		end
	end
	
	body = body .. "[@targettarget,help]"

	local index = GetMacroIndexByName(macroName)

	if index > 0 then
		EditMacro(index, macroName, 1, body, true)
	else
		index = CreateMacro(macroName, 1, body, true)
		PickupMacro(index)

		print(format("Tricks: Created new macro '%s'", macroName))
	end
end

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
	elseif not UnitIsPlayer(unit) or not UnitIsFriend("player", unit) then
		print("Tricks: Target must be a friendly player")
	else
		local name = UnitName(unit)

		evl_TricksDB[type] = name
		generateMacro()
		
		print(format("Tricks: %s target is now %s", type, name))
	end
end