function tobool(str)
	if str:lower() == "true" then return true end
	if str:lower() == "false" then return false end
end

local plrs = game:GetService("Players")
local https = game:GetService("HttpService")
local replicated = game:GetService("ReplicatedStorage")

local codename = "modderDW"
local configExt = ".json"

local lplr = plrs.LocalPlayer

local serverStuff = workspace.ServerStuff

local dealDmg = serverStuff.dealDamage
local interact = replicated.Interactables.interaction
local wepons = replicated.Weapons
local wStats = require(serverStuff.Statistics.W_STATISTICS)
local cStats = require(serverStuff.Statistics.CLASS_STATISTICS)
local drops = workspace.WeaponDrops
local efx = require(serverStuff.Statistics.S_STATISTICS)
efx.VirusA.dur = math.huge
efx.VirusB.dur = math.huge
efx.VirusC.dur = math.huge
efx.VirusD.dur = math.huge

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local bl = {
	"toxicdead",
	"toxicated",
	"bleed",
	"burning"
}
--
if not getgenv().AA1 then
	getgenv().AA1 = true
	local old
	old = hookmetamethod(game, "__namecall", function(self,...)
		local args = {...}
		if (not checkcaller()) and string.lower(getnamecallmethod()) == "kick" then
			return nil
		end
		if (not checkcaller()) and self.ClassName == "RemoteEvent" and ((tostring(self) == 'callEvent' and args[1] == 'lel') or (tostring(self) == 'dealDamage' and table.find(bl,args[1]))) then
			return nil
		end

		return old(self,...)
	end)
end
--
function upvalueFromCon(connection,i,n)
	return debug.getupvalue(getconnections(connection)[i].Function,n)
end
function getkey()
	return upvalueFromCon(dealDmg.OnClientEvent,1,13),upvalueFromCon(dealDmg.OnClientEvent,1,14)
end
function findscript()
	for i,v in pairs(lplr.Backpack:children()) do
		if v:IsA("LocalScript") and v.Name:find("-") then
			return v
		end
	end
end
--
local basestatedt = {
	{'AtkMod','atkmod','Attack power'},


	{'ShoveMod','shovemod','Make your shoves faster'},
	{'StaminaMod','stammod','Stamina'},
	{'DefenseMod','defmod','Makes you tougher but not against explosives'},
	{'LightAtkSpeed','lightatkspeed','Make your light attack faster'},
	{'HeavyAtkSpeed','heavyatkspeed','Make your heavy attack faster'},
	{'ScavMod','scavmod','Scavenge better'},
	{'MovementMod','mvtmod','Make you go fast'},
	{'TrapMod','trapmod','Plant faster'},
	{'AimMod','aimmod','Aim faster & accruate'},
	{'RecoilMod','recoilmod','Reduces recoil'},
	{'CraftCostMod','craftcostmod','Make sure to not go above 0 otherwise the craft price will be expensive'},
	{'ReloadMod','reloadmod','Reload faster'},

}
local basestatboolean = {
	{'NoMorale','nomorale','Have no morale when agent in your team dies'},
	{'NoAimMod','noaimmod','Removes your aim (Debuff)'},
	{'Backpack','backpack','Start with backpack'},
	
	{'CrippleImmune','cripple_immune','immune to cripple'},
	{'ExhaustImmune','exhaust_immune','immune to exhaust'},
	{'ExplosiveResist','explosive_resist','immune to explosive effects'},
	{'FractureImmune','frac_immune','immune to fracture'},
	{'FallDamageMod','falldamagemod','immune to fall damage'},
	{'BleedImmune','falldamagemod','immune to bleed'},
	{'BurnImmune','burnimmune','immune to burn'},
	
}
--
function Notify(name,content,image)
	Rayfield:Notify({Title=name,Content=content,Image=image})
end
--
local nostagger = true
local noinfluence = true
local startenabled = true

--
local blacklisted = {'JBox','LSMini','GMSword','EMSword','CMMaul','PLBlade'}
local spawningitem = false
local pls
function spawnitem(item)
	if spawningitem then 
		Notify("Modder", "Please wait for the cooldown", 1596283971)
		return 
	end
	spawningitem = true
	if drops:FindFirstChild(item) then
		spawningitem = false
		pls = drops:FindFirstChild(item)
		drops:FindFirstChild(item):PivotTo(workspace.CurrentCamera.CFrame*CFrame.new(0,0,-3))
	else
		local ourbench = workspace.Interactables.Workbench
		lplr.Character:PivotTo(ourbench:GetPivot()*CFrame.new(0,3,0))
		interact:FireServer(ourbench,"workbenchblueprint"..item,k1)
		wait(4)
		interact:FireServer(ourbench,"workbench",k1)
		local itema = drops:WaitForChild(item,30)
		spawningitem = false
	end
end
--

local Window = Rayfield:CreateWindow({
	Name = "Modder | Decaying winter",
	LoadingTitle = "Modder",
	LoadingSubtitle = "",
	ConfigurationSaving = {
		Enabled = false,
		FolderName = "Modder",
		FileName = "DW"
	},
	KeySystem = false, -- Set this to true to use their key system
	KeySettings = {
		Title = "",
		Subtitle = "",
		Note = "",
		SaveKey = true,
		Key = ""
	}
})

local Tab = Window:CreateTab("Player", 14546883954) -- Title, Image
local k1,k2

Tab:CreateSection("Health")

Tab:CreateButton({
	Name = "NAN Health",
	Callback = function()
		
		dealDmg:FireServer("lazarusheal",0/0,k1,k2)
		Notify("Modder", "Applied health", 14525374945) -- Notfication -- Title, Content, Image

	end,
})
Tab:CreateButton({
	Name = "Overheal ( Marks you as cheater )",
	Callback = function()
		for i = 1,300 do

			dealDmg:FireServer("lazarusheal",8,k1,k2)		
		end
		Notify("Modder", "Applied health", 14525374945)
	end,
})

Tab = Window:CreateTab("PerkEditor", 5829320333) -- Title, Image

local heys = {}

Tab:CreateSection("Config")

if not isfolder(codename) then
	makefolder(codename)
end

local configName = "default"
local configInput
configInput = Tab:CreateInput({
	Name = "Config Name",
	PlaceholderText = "config name",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		if Text == nil or Text == "" then
			Notify("Modder", "Please input valid config name", 12521878988)
			return
		end
		if string.match(Text, "%W") then
			Notify("Modder", "Config name must have no special characters", 12521878988)
			configInput:Set(configName)
			return
		end
		configName = Text
	end,
}):Set("default")
Tab:CreateButton({
	Name = "Load config",
	Callback = function()
		local content
		pcall(function()
			content = readfile(codename.."/"..configName..configExt)
		end)
		if not content then
			Notify("Modder", "Please input valid config", 2018398532)
			return
		end
		local json
		pcall(function()
			json = https:JSONDecode(content)
		end)
		if not content then
			Notify("Modder", "Not a json file", 11957180705)
			return
		end
		for i,v in pairs(json) do
			if heys[i][4] then
				local bol = tobool(v)
				heys[i][1]:Set(bol)
				heys[i][2] = bol
			else
				heys[i][1]:Set(tostring(v))
				heys[i][2] = tonumber(v)
			end
			update(heys[i][3],heys[i][2])
		end
		Notify("Modder", "Loaded config successfully", 8116168346)
	end,
})
Tab:CreateButton({
	Name = "Save config",
	Callback = function()
		Notify("Modder", "Saving config", 6164021300)
		local config = {}
		for i,v in pairs(heys) do
			config[i] = tostring(v[2])
		end
		local s,f = pcall(function()
			config = https:JSONEncode(config)
		end)
		if s then
			writefile(codename.."/"..configName..configExt,config)
			Notify("Modder", "Saved successfully", 14402210286)
		else
			Notify("Modder", f, 60826057)
		end
		
	end,
})

Tab:CreateSection("Stats")

function update(i1,v1)
	for i,v in pairs(require(workspace.ServerStuff.Statistics.CLASS_STATISTICS)) do
		if v.basestats then
			v.basestats[i1] = v1
		end
	end
end

for i,v in pairs(basestatedt) do
	local b = Tab:CreateInput({
		Name = v[1],
		PlaceholderText = "Number value",
		RemoveTextAfterFocusLost = false,
		Callback = function(Text)
			if tonumber(Text) == math.huge then
				Notify("Modder", "Value must not be infinite", 10569857544)
				return
			end
			if not tonumber(Text) then return end
			update(v[2],tonumber(Text))
			heys[v[1]][2] = tonumber(Text)
			Notify("Modder", "Edited stat", 3305312200)
		end,
	})
	heys[v[1]] = {b,"",v[2]}
end
for i,v in pairs(basestatboolean) do
	local b = Tab:CreateToggle({
		Name = v[1],
		CurrentValue = false,
		Flag = "toggle"..i, -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Value)
			update(v[2],Value)
			heys[v[1]][2] = Value
			Notify("Modder", "Edited stat", 3305312200)
		end,
	})
	heys[v[1]] = {b,"",v[2],true}
end

local noinflict = false

Tab:CreateSection("Antis")
Tab:CreateToggle({
	Name = 'AntiInfluence',
	CurrentValue = false,
	Flag = "influence", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		noinfluence = Value
		Notify("Modder", "Edited stat, Need to respawn to take effect", 3305312200)
	end,
})
Tab:CreateToggle({
	Name = 'NoInflict',
	CurrentValue = false,
	Flag = "influence", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		noinflict = Value
		Notify("Modder", "Edited stat, Need to respawn to take effect", 3305312200)
	end,
})
Tab:CreateToggle({
	Name = 'AntiStagger',
	CurrentValue = false,
	Flag = "stager", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		nostagger = Value
		Notify("Modder", "Edited stat, Need to respawn to take effect", 3305312200)
	end,
})

Tab:CreateSection("Respawn")
Tab:CreateButton({
	Name = "Go to lobby",
	Callback = function()
		workspace.ServerStuff.spawnPlayer:FireServer("respawncharacter")
		Notify("Modder", "Respawned", 3305312200)
	end,
})
Tab:CreateButton({
	Name = "Respawn",
	Callback = function()
		local stat = workspace.ServerStuff.retrieveStats:InvokeServer()
		local pgui = lplr:WaitForChild("PlayerGui")
		if pgui:FindFirstChild("mainHUD") then
			pgui:FindFirstChild("mainHUD"):Destroy()
		end
		if pgui:FindFirstChild("endgamegui") then
			pgui:FindFirstChild("endgamegui"):Destroy()
		end
		local bp = lplr:WaitForChild("Backpack")
		for i,v in pairs(bp:children()) do
			if v:IsA("LocalScript") and v.Name:find("-") then
				v:Destroy()
			end
		end
		workspace.ServerStuff.spawnPlayer:FireServer("respawncharacter")
		task.wait(3)
		workspace.ServerStuff.spawnPlayer:FireServer(stat.Class)
		task.wait(2)
		for i = 1,5 do
			task.wait(.2)
			lplr.Character:PivotTo(CFrame.new(398.916626, -1.04327083, -14.0977259, -0.0436181761, 0, 0.999048293, 0, 1, 0, -0.999048293, 0, -0.0436181761))
		end
		Notify("Modder", "Respawned", 3305312200)
	end,
})
Tab:CreateButton({
	Name = "Respawn In Place",
	Callback = function()
		local stat = workspace.ServerStuff.retrieveStats:InvokeServer()
		local pgui = lplr:WaitForChild("PlayerGui")
		if pgui:FindFirstChild("mainHUD") then
			pgui:FindFirstChild("mainHUD"):Destroy()
		end
		if pgui:FindFirstChild("endgamegui") then
			pgui:FindFirstChild("endgamegui"):Destroy()
		end
		local bp = lplr:WaitForChild("Backpack")
		for i,v in pairs(bp:children()) do
			if v:IsA("LocalScript") and v.Name:find("-") then
				v:Destroy()
			end
		end
		local cf = lplr.Character:GetPivot()
		workspace.ServerStuff.spawnPlayer:FireServer("respawncharacter")
		task.wait(3)
		workspace.ServerStuff.spawnPlayer:FireServer(stat.Class)
		repeat task.wait() until lplr.Character and lplr.Character.Parent.Name == "activePlayers"
		task.wait(2)
		lplr.Character:PivotTo(cf)
		Notify("Modder", "Respawned", 3305312200)
	end,
})

Tab = Window:CreateTab("ItemSpawner", 13459110724)

local hi = table.clone(wStats)
table.sort(hi,function(a,b)
	return a.name:lower() < b.name:lower()
end)
for i,v in pairs(hi) do
	if wepons:FindFirstChild(i) == nil or table.find(blacklisted,i) then continue end
	Tab:CreateButton({
		Name = "Spawn "..v.name,
		Callback = function()
			spawnitem(i)
		end,
	})
end

local Tab = Window:CreateTab("Teleports", 10481501007) -- Title, Image
local teles = {
	Base = CFrame.new(398.916626, -1.04327083, -14.0977259, -0.0436181761, 0, 0.999048293, 0, 1, 0, -0.999048293, 0, -0.0436181761),
	['Helipad/Last Stranded Base'] = CFrame.new(38.1867561, -0.807308912, -6.72090244, 0.0610230453, 0, 0.998136342, 0, 1, 0, -0.998136342, 0, 0.0610230453)
}
for i,v in pairs(teles) do
	Tab:CreateButton({
		Name = i,
		Callback = function()
			lplr.Character:PivotTo(v)
		end,
	})
end

function backpacko(back)
	back.ChildAdded:Connect(function(s)
		task.wait()
		if s.Name:find("-") then
			task.wait(1.5)
			local senv = getsenv(s)
			if nostagger then
				senv.stagger = function()

				end
			end
			if noinfluence then
				senv.start_influence = function()

				end
			end
			task.wait(1.5)
			k1,k2 = getkey()
			if noinflict then
				getconnections(dealDmg.OnClientEvent)[1]:Disable()
			end
		end
	end)
end

lplr.ChildAdded:Connect(function(child: Instance)  
	if child.Name == "flagged" and not lplr:GetAttribute("flagged") then
		Notify("Modder", "The game marked you as a cheater", 12936547795)		
		lplr:SetAttribute("flagged",true)
	end
	if child:IsA("Backpack") then
		backpacko(child)
	end
end)
if lplr:FindFirstChildWhichIsA("Backpack") then
	backpacko(lplr:FindFirstChildWhichIsA("Backpack"))
end
