InGameFonts = LibStub("AceAddon-3.0"):NewAddon("InGameFonts", "AceConsole-3.0")
local SML = LibStub("LibSharedMedia-3.0");

local db

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

local sharedFonts = SML.MediaTable.font

-- Add local fonts to shared font list
for k, v in pairs(InGameFontsCollection.shared) do
	sharedFonts[k] = v
end

-- create font name list
local fontOptions = { }
for k, v in pairs(sharedFonts) do
	fontOptions[k] = k;
end

local options ={
	type = "group",
	name = "In Game Fonts",
	order = 1,
    get = function(info) return db[info[#info]] end,
	set = function(info, value) 
		db[info[#info]] = value
		-- InGameFonts:ApplyValues()
	end,
	args = {
		topText = {
			type = "description",
			name = "Full client RESTART required in order to apply new values",
			order = 1
		},
		space = {
			type = "description",
			name = " ",
			order = 2
		},
		stdFont = {
			type = "select",
			name = "Standard Text Font",
			order = 10,
			desc = "No idea what this does yet",
			dialogControl = "LSM30_Font",
			values = fontOptions
		},
		unitFont = {
			type = "select",
			name = "Unit Name Font",
			order = 11,
			desc = "Affects the in world names over character's models",
			dialogControl = "LSM30_Font",
			values = fontOptions
		},
		damageFont = {
			type = "select",
			name = "Damage Font",
			order = 12,
			desc = "Affects the in world damage numbers",
			dialogControl = "LSM30_Font",
			values = fontOptions
		},
		nameplateFont = {
			type = "select",
			name = "Nameplate Font",
			order = 13,
			desc = "Affects the names and numbers seen on the default blizzard nameplates, also affects floating chat font",
			dialogControl = "LSM30_Font",
			values = fontOptions
		}
	}
}

local defaults = {
    profile =  {
		stdFont = "Friz Quadrata TT",
		unitFont = "Pragati Narrow",
		damageFont = "Orbitron",
		nameplateFont = "Pragati Narrow"
    },
}

function InGameFonts:OnInitialize()

	self.db = LibStub("AceDB-3.0"):New("InGameFontsDB", defaults)
	db = self.db.profile

	local acreg = LibStub("AceConfigRegistry-3.0")
	acreg:RegisterOptionsTable("InGameFonts", options)
	
	local acdia = LibStub("AceConfigDialog-3.0")
	acdia:AddToBlizOptions("InGameFonts", "InGameFonts")
	
	self:RegisterChatCommand("igf", "ChatCommand")

	self:ApplyValues()
end

function InGameFonts:ApplyStandardFont()
	local font = sharedFonts[self.db.profile.stdFont];
	if font then
		-- STANDARD_TEXT_FONT = font;
		-- print("Changed standard font to " .. font)
	end
end
function InGameFonts:ApplyUnitFont()
	local font = sharedFonts[self.db.profile.unitFont];
	if font then
		UNIT_NAME_FONT = font;
		-- print("Changed unit font to " .. font)
	end
end
function InGameFonts:ApplyDamageFont()
	local font = sharedFonts[self.db.profile.damageFont];
	if font then
		DAMAGE_TEXT_FONT = font;
		-- print("Changed damage font to " .. font)
	end
end
function InGameFonts:ApplyNameplateFont()
	local font = sharedFonts[self.db.profile.nameplateFont];
	if font then
		NAMEPLATE_FONT = font;
		-- print("Changed nameplate font to " .. font)
	end
end

function InGameFonts:ApplyValues()
	--print(dump(self.db.profile))
	self:ApplyStandardFont()
	self:ApplyUnitFont()
	self:ApplyDamageFont()
	self:ApplyNameplateFont()
end

function InGameFonts:ChatCommand(input)
	print("Opening In Game Fonts Config !")
	-- print(dump(origFonts))
	-- print(dump(sharedFonts))
	InterfaceOptionsFrame_OpenToCategory("InGameFonts")
end