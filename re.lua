local rs = game:GetService("RunService")
local plrs = game:WaitForChild("Players")

local char = workspace.Rig
local hum = char:FindFirstChildWhichIsA("Humanoid")
local ragdoll = hum:FindFirstChildWhichIsA("RemoteEvent") or 
	rs:IsStudio() and hum:FindFirstChildWhichIsA("BindableEvent")
local root = hum.RootPart

if not ragdoll then return end

local d = Instance.new("HumanoidDescription")
d.BodyTypeScale = 0
d.ProportionScale = 0

local fakedude = plrs:CreateHumanoidModelFromDescription(d,Enum.HumanoidRigType.R15)
local fakeHum = fakedude.Humanoid

fakedude.Parent = workspace
fakedude:PivotTo(char:GetPivot())

d:Destroy()

local queue = {{},{}}

function doRagdoll(b)
	if ragdoll:IsA("RemoteEvent") then
		ragdoll:FireServer(b)
	elseif ragdoll:IsA("BindableEvent") then
		ragdoll:Fire(b)
	end
end
function move(p,cf)
	table.insert(queue[1],p)
	table.insert(queue[2],cf)
end
function animate(p0,p1,p2,name)
	local cf = p1.CFrame
	if name:find("Arm") or name:find("Leg") then
		cf*=CFrame.new(0,.2,0)
	end
	if name == "HumanoidRootPart" then
		cf = p1.CFrame*CFrame.new(0,-.2,0)
	end
	move(p0,cf)
end
function setModelVelocity(m,vel)
	for i,v in pairs(m:children()) do
		if v:IsA("BasePart") then
			v.Velocity = vel
		end
	end
end
function setModelCollide(m,vel)
	for i,v in pairs(m:children()) do
		if v:IsA("BasePart") then
			v.CanCollide = vel
		end
	end
end
function setModelTransparency(m,vel)
	for i,v in pairs(m:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = vel
		end
	end
end

fakedude.Head.face:Destroy()

local identifiers = {
	['LeftLowerArm'] = 'Left Arm',
	['RightLowerArm'] = 'Right Arm',
	['LeftLowerLeg'] = 'Left Leg',
	['RightLowerLeg'] = 'Right Leg',
	[{'UpperTorso','LowerTorso'}] = 'HumanoidRootPart',
	['Head'] = 'Head',
}

local t = 0
doRagdoll(true)
setModelTransparency(fakedude,.7)
local heartbeat = rs.Heartbeat:Connect(function()
	if tick()-t > 1/15 then
		t = tick()
		doRagdoll(true)
	end
	for i,v in pairs(identifiers) do
		local part
		local part2
		if type(i) == 'table' then
			part = fakedude:FindFirstChild(i[1])
			part2 = fakedude:FindFirstChild(i[2])
		else
			part = fakedude:FindFirstChild(i)
		end
		if char:FindFirstChild(v) then
			local tp = char:FindFirstChild(v)
			animate(tp,part,part2,v)
		end
	end
	workspace:BulkMoveTo(queue[1],queue[2],Enum.BulkMoveMode.FireCFrameChanged)
	queue = {{},{}}
end)
local step = rs.Stepped:Connect(function()
	setModelVelocity(char,Vector3.zero)
	setModelCollide(char,false)
	
	fakeHum:Move(hum.MoveDirection,false)
	fakeHum.Jump = hum.Jump
end)
local connections = {heartbeat,step}
function disconnect()
	fakedude:Destroy()
	for i,v in pairs(connections) do
		v:Disconnect()
	end
	connections = nil
end
table.insert(connections,hum.Died:Connect(disconnect))
table.insert(connections,char.AncestryChanged:Connect(disconnect))

local animator = loadstring(game:HttpGet'https://glot.io/snippets/ggi1icrgri/raw/animator15.lua')()
local keyframe = game:GetObjects('rbxassetid://14898621309')[1]
local anim = animator(fakedude,keyframe,{loadseq=true,seq=keyframe})
anim:Play()
anim.Looped = true
