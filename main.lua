--- VARIABLES ---

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local drag_module = {}
local drag_cache = {}

local current_camera = workspace.CurrentCamera

--- VARIABLES ---

--- FUNCTIONS ---

function update_gui_drag(ui : GuiObject, input : InputObject)
	local drag_data = drag_cache[ui]
	if not drag_data then return end
	local delta = input.Position - drag_data.drag_start
	local new_ui_position = UDim2.new(drag_data.start_pos.X.Scale, drag_data.start_pos.X.Offset + delta.X, drag_data.start_pos.Y.Scale, drag_data.start_pos.Y.Offset + delta.Y)

	if ReplicatedStorage:GetAttribute("rizzed") then -- drag_data.pass_screen
		local screen_size = current_camera.ViewportSize
		local gui_size = ui.AbsoluteSize

		new_ui_position = UDim2.new(
			0, math.clamp(new_ui_position.X.Offset, 0, screen_size.X - gui_size.X),
			0, math.clamp(new_ui_position.Y.Offset, 0, screen_size.Y - gui_size.Y)
		)
	end

	ui.Position = new_ui_position
end

function new_drag(ui : GuiObject, pass_screen : boolean)
	if not ui then return end
	drag_cache[ui] = {
		dragging = nil,
		drag_input = nil,
		drag_start = nil,
		start_pos = nil,
		pass_screen = pass_screen or false,
	}

	ui.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local ui_data = drag_cache[ui]

		ui_data.dragging = true
		ui_data.drag_start = input.Position
		ui_data.start_pos = ui.Position

		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then return end
			ui_data.dragging = false
		end)
	end)

	ui.InputChanged:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local ui_data = drag_cache[ui]
		ui_data.drag_input = input
	end)
end

function print_warn(str : string)
	print(`\n===== ===== =====\n{str}\n===== ===== =====`)
end

function wrap_text_table(string_table : {} | string)
	local _return = {}
	for index, value in (typeof(string_table) == "table" and string_table or {string_table}) do
		_return[index] = typeof(value) == "table" and value or `"{value}"`
	end
	return _return
end

function build_ui()
	local rizzed = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local template = Instance.new("TextButton")
	local UIListLayout = Instance.new("UIListLayout")
	local detail = Instance.new("Frame")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local method = Instance.new("TextLabel")
	local remote = Instance.new("TextLabel")
	local argument = Instance.new("TextLabel")
	local clear = Instance.new("TextButton")
	
	new_drag(Frame)

	rizzed.Name = "rizzed"
	rizzed.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	rizzed.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Frame.Parent = rizzed
	Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0.514981389, 0, 0.101123713, 0)
	Frame.Size = UDim2.new(0.275000006, 0, 0.400000006, 0)

	ScrollingFrame.Parent = Frame
	ScrollingFrame.Active = true
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Size = UDim2.new(0.349999994, 0, 1, 0)
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

	template.Name = "template"
	template.Parent = ScrollingFrame
	template.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	template.BorderColor3 = Color3.fromRGB(0, 0, 0)
	template.BorderSizePixel = 0
	template.Size = UDim2.new(1, 0, 0.100000001, 0)
	template.Visible = false
	template.Font = Enum.Font.SourceSans
	template.TextColor3 = Color3.fromRGB(0, 0, 0)
	template.TextSize = 14.000

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	detail.Name = "detail"
	detail.Parent = Frame
	detail.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	detail.BackgroundTransparency = 1.000
	detail.BorderColor3 = Color3.fromRGB(0, 0, 0)
	detail.BorderSizePixel = 0
	detail.Position = UDim2.new(0.349999934, 0, -0.00468193367, 0)
	detail.Size = UDim2.new(0.644999981, 0, 1, 0)

	UIListLayout_2.Parent = detail
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

	method.Name = "method"
	method.Parent = detail
	method.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	method.BackgroundTransparency = 1.000
	method.BorderColor3 = Color3.fromRGB(0, 0, 0)
	method.BorderSizePixel = 0
	method.Size = UDim2.new(1, 0, 0.100000001, 0)
	method.Font = Enum.Font.Gotham
	method.Text = "METHOD : InvokeServer"
	method.TextColor3 = Color3.fromRGB(255, 255, 255)
	method.TextScaled = true
	method.TextSize = 14.000
	method.TextWrapped = true

	remote.Name = "remote"
	remote.Parent = detail
	remote.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	remote.BackgroundTransparency = 1.000
	remote.BorderColor3 = Color3.fromRGB(0, 0, 0)
	remote.BorderSizePixel = 0
	remote.LayoutOrder = 1
	remote.Size = UDim2.new(1, 0, 0.100000001, 0)
	remote.Font = Enum.Font.Gotham
	remote.Text = "REMOTE_NAME : req1"
	remote.TextColor3 = Color3.fromRGB(255, 255, 255)
	remote.TextScaled = true
	remote.TextSize = 14.000
	remote.TextWrapped = true

	argument.Name = "argument"
	argument.Parent = detail
	argument.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	argument.BackgroundTransparency = 1.000
	argument.BorderColor3 = Color3.fromRGB(0, 0, 0)
	argument.BorderSizePixel = 0
	argument.LayoutOrder = 2
	argument.Size = UDim2.new(1, 0, 0.100000001, 0)
	argument.Font = Enum.Font.Gotham
	argument.Text = "ARGUMENTS : args1, args2"
	argument.TextColor3 = Color3.fromRGB(255, 255, 255)
	argument.TextScaled = true
	argument.TextSize = 14.000
	argument.TextWrapped = true

	clear.Name = "clear"
	clear.Parent = Frame
	clear.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	clear.BorderColor3 = Color3.fromRGB(0, 0, 0)
	clear.BorderSizePixel = 0
	clear.Position = UDim2.new(0, 0, 1.03464413, 0)
	clear.Size = UDim2.new(0.300000012, 0, 0.100000001, 0)
	clear.Font = Enum.Font.Gotham
	clear.Text = "clear logs"
	clear.TextColor3 = Color3.fromRGB(0, 0, 0)
	clear.TextScaled = true
	clear.TextSize = 14.000
	clear.TextWrapped = true
	
	return rizzed
end

function create_remote_call(ui, method, call_name, arguments)
	method = method or "failed777"
	call_name = call_name or "failed777"
	arguments = arguments or {}
	
	local ui_clone = ui.Frame.ScrollingFrame.template:Clone()
	ui_clone.Text = `{call_name} - {method}`
	ui_clone.Visible = true
	ui_clone.Parent = ui.Frame.ScrollingFrame
	
	ui_clone.Activated:Connect(function()
		ui.Frame.detail.method.Text = `METHOD : {method}`
		ui.Frame.detail.remote.Text = `CALL NAME : {call_name}`
		ui.Frame.detail.argument.Text = `ARGUMENTS : {table.concat((function() local _return = {} for _, argument in arguments do table.insert(_return, `"{argument}"`) end return _return end)(), " ,")}`
	end)
end

--- FUNCTIONS ---

--- INITIALIZE ---

local ui = build_ui()

ui.Frame.clear.Activated:Connect(function()
	for _, object in ui.Frame.ScrollingFrame:GetChildren() do
		if object:IsA("GuiObject") and object.Visible then object:Destroy() end
	end
end)

UserInputService.InputChanged:Connect(function(input)
	for ui, ui_data in drag_cache do
		if input ~= ui_data.drag_input or not ui_data.dragging then continue end
		update_gui_drag(ui, input)
	end
end)

local action = 1
local blacklist = {"Get Stats", "Player Statues: Get Statue Data"}
if not _G.blacklist_hook or action == 2 then print_warn(`>>> HOOK BLACK LIST SET\nORIGINAL : {(_G.blacklist_hook and typeof(_G.blacklist_hook == "table") and #_G.blacklist_hook >= 1) and table.concat(wrap_text_table(_G.blacklist_hook), " | ") or "no blacklist/invalid blacklist"}\nNEW : {(blacklist and typeof(blacklist) == "table" and #blacklist >= 1) and table.concat(wrap_text_table(blacklist), " | ") or "no blacklist/invalid blacklist"}`)print(`BLACKLIST SET `) _G.blacklist_hook = blacklist end
if action ~= 1 then return end

print("INITIALIZED")

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local method = getnamecallmethod()
	if not checkcaller() and (method == "InvokeServer" or method == "FireServer") and not table.find(_G.blacklist_hook, tostring(self)) then 
		create_remote_call(ui, method, self, {...})
		return 
	end
	return oldNamecall(self, ...)
end))

print(`HOOK METHOD :`)
print(oldNamecall)

--print_warn(`METHOD : {method}\nREMOTE CALL NAME : {table.concat(wrap_text_table(self), " | ")}\nARGUMENTS : {table.concat(wrap_text_table({ ... }), " | ")}`) 
--]]
