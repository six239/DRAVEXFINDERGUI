
-- DRAVEX SERVER GUI | NEON PURPLE EDITION
-- Public server finder for Steal a Brainrot

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PLACE_ID = 109983668079237
local INVITE = "https://discord.gg/5C8vHuPxh"

local COLORS = {
    bg = Color3.fromRGB(19, 7, 30),
    panel = Color3.fromRGB(38, 12, 58),
    entry = Color3.fromRGB(49, 18, 73),
    purple = Color3.fromRGB(195, 45, 255),
    neon = Color3.fromRGB(225, 125, 255),
    white = Color3.fromRGB(255, 245, 255),
    muted = Color3.fromRGB(195, 170, 215),
    green = Color3.fromRGB(100, 255, 160),
}

local guiParent = player:WaitForChild("PlayerGui")
local old = guiParent:FindFirstChild("DravexServerGUI")
if old then old:Destroy() end

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    make("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, obj)
end

local function stroke(obj, color, thickness)
    make("UIStroke", {
        Color = color or COLORS.purple,
        Thickness = thickness or 1.5
    }, obj)
end

local function label(parent, text, size, pos, textSize)
    return make("TextLabel", {
        Size = size,
        Position = pos,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = COLORS.white,
        TextSize = textSize or 13,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    }, parent)
end

local function button(parent, text, size, pos)
    local b = make("TextButton", {
        Size = size,
        Position = pos,
        BackgroundColor3 = COLORS.entry,
        Text = text,
        TextColor3 = COLORS.white,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = true
    }, parent)
    round(b, 8)
    stroke(b, COLORS.purple, 1)
    return b
end

local gui = make("ScreenGui", {
    Name = "DravexServerGUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, guiParent)

local main = make("Frame", {
    Name = "MainFrame",
    Size = UDim2.fromOffset(520, 405),
    Position = UDim2.new(0.5, -260, 0.5, -202),
    BackgroundColor3 = COLORS.bg,
    BorderSizePixel = 0,
    Active = true
}, gui)

round(main, 12)
stroke(main, COLORS.neon, 2)

make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(68, 17, 105)),
        ColorSequenceKeypoint.new(0.5, COLORS.panel),
        ColorSequenceKeypoint.new(1, COLORS.bg)
    }),
    Rotation = 35
}, main)

local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 52),
    BackgroundColor3 = COLORS.panel,
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0
}, main)
round(header, 12)

local title = label(
    header, "Dravex Server GUI",
    UDim2.new(1, -100, 1, 0),
    UDim2.fromOffset(15, 0), 19
)
title.Font = Enum.Font.GothamBlack
title.TextColor3 = COLORS.neon

local minimize = button(
    header, "—", UDim2.fromOffset(32, 30),
    UDim2.new(1, -75, 0, 11)
)
local close = button(
    header, "X", UDim2.fromOffset(32, 30),
    UDim2.new(1, -38, 0, 11)
)

local serversTab = button(
    main, "SERVER FINDER",
    UDim2.fromOffset(145, 32),
    UDim2.fromOffset(14, 61)
)
local discordTab = button(
    main, "DISCORD",
    UDim2.fromOffset(105, 32),
    UDim2.fromOffset(168, 61)
)

local serverPage = make("Frame", {
    Size = UDim2.new(1, -28, 1, -119),
    Position = UDim2.fromOffset(14, 103),
    BackgroundTransparency = 1
}, main)

local status = label(
    serverPage, "Ready to search.",
    UDim2.new(1, -112, 0, 28),
    UDim2.new(0, 0, 0, 0), 12
)
status.TextColor3 = COLORS.muted

local refresh = button(
    serverPage, "REFRESH",
    UDim2.fromOffset(100, 28),
    UDim2.new(1, -100, 0, 0)
)

local list = make("ScrollingFrame", {
    Name = "ServerList",
    Size = UDim2.new(1, 0, 1, -38),
    Position = UDim2.fromOffset(0, 38),
    BackgroundColor3 = COLORS.bg,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = COLORS.purple,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new()
}, serverPage)

round(list, 8)
stroke(list, COLORS.purple, 1)

make("UIPadding", {
    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8)
}, list)

make("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder
}, list)

local discordPage = make("Frame", {
    Size = serverPage.Size,
    Position = serverPage.Position,
    BackgroundTransparency = 1,
    Visible = false
}, main)

local discordTitle = label(
    discordPage, "DRAVEX COMMUNITY",
    UDim2.new(1, 0, 0, 45),
    UDim2.fromOffset(0, 25), 22
)
discordTitle.TextColor3 = COLORS.neon
discordTitle.Font = Enum.Font.GothamBlack
discordTitle.TextXAlignment = Enum.TextXAlignment.Center

local inviteLabel = make("TextLabel", {
    Size = UDim2.new(1, -20, 0, 42),
    Position = UDim2.fromOffset(10, 90),
    BackgroundColor3 = COLORS.entry,
    Text = INVITE,
    TextColor3 = COLORS.white,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    BorderSizePixel = 0
}, discordPage)
round(inviteLabel, 8)

local copy = button(
    discordPage, "COPY DISCORD INVITE",
    UDim2.fromOffset(190, 38),
    UDim2.new(0.5, -95, 0, 150)
)

local function getClipboard()
    if typeof(setclipboard) == "function" then
        return setclipboard
    elseif typeof(toclipboard) == "function" then
        return toclipboard
    end
end

copy.MouseButton1Click:Connect(function()
    local clipboard = getClipboard()
    if clipboard then
        local ok = pcall(clipboard, INVITE)
        copy.Text = ok and "COPIED!" or "COPY FAILED"
    else
        copy.Text = "COPY MANUALLY"
    end
    task.delay(2, function()
        if copy.Parent then copy.Text = "COPY DISCORD INVITE" end
    end)
end)

serversTab.MouseButton1Click:Connect(function()
    serverPage.Visible = true
    discordPage.Visible = false
end)

discordTab.MouseButton1Click:Connect(function()
    serverPage.Visible = false
    discordPage.Visible = true
end)

-- Drag the panel
local dragging, dragStart, startPos = false, nil, nil

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local restore = button(
    gui, "D", UDim2.fromOffset(48, 48),
    UDim2.new(0, 20, 0.5, -24)
)
restore.TextSize = 22
restore.Visible = false

minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    restore.Visible = true
end)

restore.MouseButton1Click:Connect(function()
    main.Visible = true
    restore.Visible = false
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- HTTP request support
local requestFunc

if typeof(syn) == "table" and typeof(syn.request) == "function" then
    requestFunc = syn.request
elseif typeof(http) == "table" and typeof(http.request) == "function" then
    requestFunc = http.request
elseif typeof(http_request) == "function" then
    requestFunc = http_request
elseif typeof(request) == "function" then
    requestFunc = request
end

local searching = false

local function clearList()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

local function addServer(server, index)
    local entry = make("Frame", {
        Size = UDim2.new(1, -4, 0, 65),
        BackgroundColor3 = COLORS.entry,
        BorderSizePixel = 0,
        LayoutOrder = index
    }, list)
    round(entry, 8)
    stroke(entry, COLORS.purple, 1)

    local count = tonumber(server.playing) or 0

    label(
        entry, "Public Server #" .. index,
        UDim2.new(1, -95, 0, 25),
        UDim2.fromOffset(9, 5), 13
    ).Font = Enum.Font.GothamBold

    local info = label(
        entry,
        tostring(count) .. " / " .. tostring(server.maxPlayers or "?") .. " players",
        UDim2.new(1, -95, 0, 22),
        UDim2.fromOffset(9, 31), 12
    )
    info.TextColor3 = COLORS.green

    local join = button(
        entry, "JOIN",
        UDim2.fromOffset(70, 32),
        UDim2.new(1, -80, 0.5, -16)
    )

    join.MouseButton1Click:Connect(function()
        status.Text = "Attempting to join..."
        local ok, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(
                PLACE_ID, server.id, player
            )
        end)
        if not ok then
            status.Text = "Join failed: " .. tostring(err)
            join.Text = "RETRY"
        end
    end)
end

local function fetchServers()
    if searching then return end
    searching = true
    refresh.Text = "SEARCHING"
    status.Text = "Fetching public servers..."
    clearList()

    if not requestFunc then
        status.Text = "This executor has no supported HTTP request API."
        refresh.Text = "REFRESH"
        searching = false
        return
    end

    local cursor = ""
    local seen = {}
    local found = 0
    local pages = 0

    repeat
        local url = "https://games.roblox.com/v1/games/"
            .. PLACE_ID
            .. "/servers/Public?sortOrder=Asc&limit=100"

        if cursor ~= "" then
            url = url .. "&cursor=" .. HttpService:UrlEncode(cursor)
        end

        local ok, response = pcall(function()
            return requestFunc({
                Url = url,
                Method = "GET",
                Headers = {["Accept"] = "application/json"}
            })
        end)

        if not ok or not response then
            status.Text = "Server request failed. Try again."
            break
        end

        local code = tonumber(response.StatusCode or response.Status)
        if code and code ~= 200 then
            status.Text = "Server API error: " .. code
            break
        end

        local decoded, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not decoded or type(data) ~= "table" then
            status.Text = "Invalid server API response."
            break
        end

        for _, server in ipairs(data.data or {}) do
            local count = tonumber(server.playing) or 0
            if count <= 1 and server.id and not seen[server.id] then
                seen[server.id] = true
                found = found + 1
                addServer(server, found)
            end
        end

        cursor = data.nextPageCursor or ""
        pages = pages + 1
    until cursor == "" or pages >= 3 or not searching

    if searching and status.Text == "Fetching public servers..." then
        status.Text = "Found " .. found .. " servers with 0-1 players."
        if found == 0 then
            status.Text = "No matching servers found. Refresh to retry."
        end
    end

    refresh.Text = "REFRESH"
    searching = false
end

refresh.MouseButton1Click:Connect(function()
    task.spawn(fetchServers)
end)

task.spawn(fetchServers)

print("Dravex Server GUI loaded")
