local wait = function(t)
	t = t or 0.0035
	local c = tick()
	repeat game:GetService("RunService").Heartbeat:Wait() until tick()-c >= t
	return true
end

local startX = -366.5
local startZ = -261.5

local length = 2

local nodes = {}
local cList = {}

local start
local finish

local current
local outside = {}

local function findClosest(n)
	local closest = nil
	local dist = math.huge
	
	for i,v in pairs(n) do
		local mag = (finish.Position-v.Position).Magnitude
		if mag <= dist then
			closest = v
			dist = mag
		end
		if i%10 == 0 then
			wait()
		end
	end
	
	return closest
end

local function getNearest(p)
	if not p then
		return {}
	end
	local n = {}
	
	local r = (p.CFrame.RightVector)*5
	local l = -r
	local f = (p.CFrame.LookVector)*5
	local b = -f
	local rp = RaycastParams.new()
	rp.FilterDescendantsInstances = workspace.Nodes:GetChildren()
	rp.FilterType = Enum.RaycastFilterType.Whitelist
	
	local ra = workspace:Raycast(p.Position, r, rp)
	local la = workspace:Raycast(p.Position, l, rp)
	local fa = workspace:Raycast(p.Position, f, rp)
	local ba = workspace:Raycast(p.Position, b, rp)
	if ra and not table.find(cList, ra.Instance) then
		table.insert(n, ra.Instance)
	end
	if la and not table.find(cList, la.Instance) then
		table.insert(n, la.Instance)
	end
	if fa and not table.find(cList, fa.Instance) then
		table.insert(n, fa.Instance)
	end
	if ba and not table.find(cList, ba.Instance) then
		table.insert(n, ba.Instance)
	end
	
	p.BrickColor = BrickColor.new("Toothpaste")
	
	return n
end

local function run()
	local nodes = {}
	
	for i=1, 75 do -- 151
		for v=1, 75 do -- 100
			local posX = startX + ((i-1)*5)
			local posZ = startZ + ((v-1)*5)
			
			local node = Instance.new("Part")
			node.Size = Vector3.new(2,2,2)
			node.Anchored = true
			node.CanCollide = false
			node.Name = v..'-'..i
			
			node.Position = Vector3.new(posX, 3.5, posZ)
			node.Parent = workspace.Nodes
			
			local rid = math.random(1, 3)
			if rid == 1 then
				node:Destroy()
			end
		end
		if i%5==0 then
			wait()
		end
	end
	
	start = workspace.Nodes:GetChildren()[math.random(1, #workspace.Nodes:GetChildren())]
	finish = workspace.Nodes:GetChildren()[math.random(1, #workspace.Nodes:GetChildren())]
	
	start.BrickColor = BrickColor.new("Really red")
	finish.BrickColor = BrickColor.new("Lime green")
	start.Name = 'start'
	finish.Name = 'endd'
	local s = start:Clone()
	s.Parent = workspace
	s.Size = Vector3.new(1, 100, 1)
	s.BrickColor = BrickColor.new("Electric blue")
	local s = finish:Clone()
	s.Parent = workspace
	s.Size = Vector3.new(1, 100, 1)
	s.BrickColor = BrickColor.new("Electric blue")
	
	for i,node in pairs(workspace.Nodes:GetChildren()) do
		nodes[node.Name] = {}
		nodes[node.Name]["v"] = 0
		nodes[node.Name]['last'] = nil
		if i%50 == 0 then
			wait()
		end
	end
	
	current = start
	outside = {start}
	
	repeat wait() current = start until current ~= nil
	
	local finished = false
	local faileda = false
	
	while wait() do
		local failed = 0
		local noutside = {}
		for i,v in pairs(outside) do
			local ne = getNearest(v)
			if #ne == 0 then
				failed = failed + 1
				continue
			end
			
			for j,k in pairs(ne) do
				table.insert(noutside, k)
				table.insert(cList, k)
				
				if nodes[k.Name] then
					nodes[k.Name]['v'] = nodes[v.Name]['v'] + 1
					nodes[k.Name]['last'] = v
				end
				
				if k == finish then
					finished = true
					break
				end
				if j%100 == 0 then
					wait()
				end
			end
			
			if finished then
				break
			end
			
			if i%100 == 0 then
				wait()
			end
		end
		
		outside = noutside
		
		if finished then
			break
		end
		
		if failed == #outside then
			warn("Script could not find a path!")
			faileda = true
			break
		end
	end
	
	if not faileda then
		local path = {finish}
	
		local v = finish
		repeat
			if v then
				v = nodes[v.Name]['last']
				table.insert(path, v)
			end
			wait()
		until v == start
		
		for i = #path,1,-1 do
			local v = path[i]
			v.BrickColor = BrickColor.new("Royal purple")
			wait()
		end
		
		finished = false
		finish.BrickColor = BrickColor.new("Lime green")
	end
end

while true do
	run()
	wait(2)
	for i,v in pairs(workspace.Nodes:GetChildren()) do
		v:Destroy()
		if i%250 == 0 then
			wait()
		end
	end
	workspace:FindFirstChild("start"):Destroy()
	workspace:FindFirstChild("endd"):Destroy()
end
