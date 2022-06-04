local Functions = {}

Functions["Services"] = setmetatable({}, {
    __index = function(self, I)
        if pcall(function() game:FindService(I) end) then
            return game:GetService(I)
        end
    end,
})

Functions["Create"] = function(Class, Properties)
    local Obj, Properties = Instance.new(Class), Properties or {}
    for I, V in pairs(Properties) do if rawequal(I, "Parent") then continue end Obj[I] = V; end
    if Properties["Parent"] then Obj["Parent"] = Properties["Parent"] end; return Obj
end

Functions["Tween"] = function(Obj, Time, Style, Direction, Goal)
    local T = Functions["Services"]["TweenService"]:Create(
        Obj, TweenInfo.new(Time, Enum["EasingStyle"][Style], Enum["EasingDirection"][Direction]), Goal
    ); T:Play(); return T
end

Functions["Yield"] = function(Amount)
    local Index = 0
    repeat 
        game["RobloxReplicatedStorage"]["GetServerVersion"]:InvokeServer()
        Index = Index + 1
    until Index >= Amount
end

Functions["Clock"] = function(Time, Type)
	if Type == "Create" then
		local Diff = os.clock() - Time
		local Min = math.floor(Diff / 60)
		local Sec = math.floor(Diff - Min * 60)
		local Mil = math.floor((Sec - math.floor(Sec)) * 10)
		return Min .. " : " .. Sec .. " : " .. Mil
	elseif Type == "Set" then
		if Time >= 1 then
			local Min = string.format("%2.f", math.floor(Time / 60))
			local Sec = string.format("%02.f", math.floor(Time - Min * 60))
			return Min .. ":" .. Sec else return "0:0"
		end
	end
end

Functions["ParseColor"] = function(str)
	if (str):find("%d+%s*,%s*%d+%s*,%s*%d+") then
		local s, e = (str):find("%d+%s*,%s*%d+%s*,%s*%d+");
		local sub = (str):sub(s, e);
		local r, g, b;
		local a, b = (str):find("%d+%s*,");
		local r1 = (str):sub(a, b);
		local c, d = (str):find("%d+%s*,", b);
		local g1 = (str):sub(c, d);
		local e, f = (str):find("%s*%d+", d);
		local b1 = (str):sub(e, f);
		r = tonumber((r1):sub((r1):find("%d+")));
		g = tonumber((g1):sub((g1):find("%d+")));
		b = tonumber((b1):sub((b1):find("%d+")));
		return r, g, b;
	end
end

Functions["CheckAssetId"] = function(ID, Type)
	local AssetId = nil
	local Success, Result = pcall(function()
		return Services["MPS"]:GetProductInfo(ID, Enum["InfoType"]["Asset"])
	end); if Success then AssetId = Services["MarketplaceService"]:GetProductInfo(ID)
		if AssetId and AssetId["AssetTypeId"] == Type then return true
		elseif AssetId["AssetTypeId"] ~= Type then return false end
		elseif not Success then return false
	end
end

Functions["HasProperty"] = function(Obj, Property)
    if pcall(function() local T = Obj[Property] end) then
        return true else return false
    end
end

Functions["FindPlayer"] = function(Name)
    Name = Name:lower()
    for I, V in pairs(Services["Players"]:GetPlayers()) do
        if Name == (V["Name"]:lower()):sub(1, #Name) or Name == (V["DisplayName"]:lower()):sub(1, #Name) then return V end
    end
end

Functions["GetMass"] = function(Model)
    local Mass = 0;
    if Type == "Assembly" then
        for I, V in pairs(Model:GetDescendants()) do
            if V:IsA("BasePart") then Mass = Mass + V["AssemblyMass"] end
        end
    elseif Type == "Regular" then
        for I, V in pairs(Model:GetDescendants()) do
            if V:IsA("BasePart") then Mass = Mass + V:GetMass() end
        end
    end; return Mass;
end

Functions["CheckMouseInFrame"] = function(Frame)
	local Y = Frame["AbsolutePosition"]["Y"] <= Mouse["Y"] and Mouse["Y"] <= Frame["AbsolutePosition"]["Y"] + Frame["AbsoluteSize"]["Y"]
	local X = Frame["AbsolutePosition"]["X"] <= Mouse["X"] and Mouse["X"] <= Frame["AbsolutePosition"]["X"] + Frame["AbsoluteSize"]["X"]
	return (Y and X)
end

Functions["LerpCalc"] = function(A, B, T)
    return A + (B - A) * T
end

Functions["URLEncode"] = function(Input)
    return Services["HttpService"]:UrlEncode(Input)
end

Functions["JSONEncode"] = function(Input)
    return Services["HttpService"]:JSONEncode(Input)
end

Functions["JSONDecode"] = function(Input)
    return Services["HttpService"]:JSONDecode(Input)
end

return Functions
