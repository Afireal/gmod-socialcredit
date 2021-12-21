
local menuTitle = "Social credit system"
local menuSize = {w = 400, h = 500}

local emptyFunction = function() end

local license = [[
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.
	
In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.
	
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
	
For more information, please refer to <http://unlicense.org/>
]]

function socialcredit.OpenMenu(_, pnl)

	if !IsValid(pnl) then

		pnl = vgui.Create("DFrame")
		pnl:SetSize(menuSize.w, menuSize.h)
		pnl:Center()
		pnl:MakePopup()
		pnl:SetTitle(menuTitle)

	end

	local SHEET = vgui.Create("DPropertySheet", pnl)
	SHEET:Dock(FILL)

	local SCOREBOARD = vgui.Create("DPanel", SHEET)
	SCOREBOARD:Dock(FILL)
	SCOREBOARD:DockMargin(2, 2, 2, 2)
	SCOREBOARD.Paint = emptyFunction
	SHEET:AddSheet(socialcredit.Localize("scoreboard"), SCOREBOARD, "icon16/group.png")

	SCOREBOARD.List = vgui.Create("DListView", SCOREBOARD)
	SCOREBOARD.List:Dock(FILL)
	SCOREBOARD.List:DockMargin(2, 2, 2, 2)
	SCOREBOARD.List:SetMultiSelect(false)
	SCOREBOARD.List:AddColumn(socialcredit.Localize("playerName"))
	SCOREBOARD.List:AddColumn(socialcredit.Localize("playerCredit")):SetFixedWidth(100)

	SCOREBOARD.List.Update = function(self)
	
		self:Clear()
	
		for _, ply in pairs(player.GetAll()) do
		
			local LINE = SCOREBOARD.List:AddLine(ply:Name(), ply:GetSocialCredit())
			LINE.Player = ply
		
		end
	
	end

	SCOREBOARD.List.OnRowSelected = function(self, rid, pnl)
	
		local ply = pnl.Player
		if !ply then return end

		local setCredit = socialcredit.Localize("setCredit")
		local steamid = ply:SteamID()

		local MENU = DermaMenu()
		MENU:AddOption(setCredit, function()

			Derma_StringRequest(setCredit, socialcredit.Localize("inputNumber"), tostring(socialcredit.Config.DefaultValue), function(input)
			
				input = tonumber(input)
				if !isnumber(input) then return end

				RunConsoleCommand("say", "/setcredit "..steamid.." "..input)
				SCOREBOARD.List:Update()
			
			end)
		
		end):SetIcon("icon16/page_edit.png")
		MENU:AddOption(socialcredit.Localize("copySteamID"), function()
		
			SetClipboardText(steamid)
		
		end):SetIcon("icon16/page_copy.png")
		MENU:Open()
	
	end

	SCOREBOARD.Buttons = vgui.Create("DPanel", SCOREBOARD)
	SCOREBOARD.Buttons:Dock(BOTTOM)
	SCOREBOARD.Buttons:DockMargin(2, 2, 2, 2)

	SCOREBOARD.Buttons.Update = vgui.Create("DButton", SCOREBOARD.Buttons)
	SCOREBOARD.Buttons.Update:Dock(RIGHT)
	SCOREBOARD.Buttons.Update:DockMargin(1, 1, 1, 1)
	SCOREBOARD.Buttons.Update:SetSize(150, 0)
	SCOREBOARD.Buttons.Update:SetText(socialcredit.Localize("update"))
	SCOREBOARD.Buttons.Update:SetIcon("icon16/arrow_refresh_small.png")

	SCOREBOARD.Buttons.Update.DoClick = function()
	
		SCOREBOARD.List:Update()
	
	end

	local SETTINGS = vgui.Create("DScrollPanel", SHEET)
	SETTINGS:Dock(FILL)
	SETTINGS:DockMargin(2, 2, 2, 2)
	SETTINGS.Paint = emptyFunction
	SHEET:AddSheet(socialcredit.Localize("settings"), SETTINGS, "icon16/cog.png")

	SETTINGS.Update = function(self)
	
		self:Clear()

		for id, params in pairs(socialcredit.GetFeatures()) do
		
			local FORM = vgui.Create("DForm", self)
			FORM:Dock(TOP)
			FORM:DockMargin(2, 1, 2, 1)
			FORM:SetExpanded(false)
			FORM:SetName(socialcredit.Localize(id))

			local function checkBox(label, convar)
			
				local var = GetConVar(convar)
				if !var then return end

				local pnl = FORM:CheckBox(label)
				pnl:SetChecked(var:GetBool())

				pnl.Button.OnChange = function(s, v)

					if !CAMI.PlayerHasAccess(LocalPlayer(), socialcredit.Privilege) then return end

					local data = socialcredit.utils.Transcript {
					
						conVar = convar,
						value = v and 1 or 0
					
					}

					print(convar, v)

					net.Start("SocialCreditControl", true)

						net.WriteInt(#data, 17)
						net.WriteData(data)

					net.SendToServer()

				end
			
			end

			local function numSlider(label, convar, min, max)
			
				local var = GetConVar(convar)
				if !var then return end

				local pnl = FORM:NumSlider(label, nil, min, max, 0)
				pnl:SetValue(var:GetInt())

				pnl.OnValueChanged = function(s, v)

					if s._ignore then return end
					if !CAMI.PlayerHasAccess(LocalPlayer(), socialcredit.Privilege) then return end

					timer.Create("SocialCredit.ChangeConvar", 0.3, 1, function() 
					
						local data = socialcredit.utils.Transcript {
					
							conVar = convar,
							value = v
						
						}
	
						net.Start("SocialCreditControl", true)
	
							net.WriteInt(#data, 17)
							net.WriteData(data)
	
						net.SendToServer()
					
					end)

				end
			
			end

			checkBox(socialcredit.Localize("enableFeature"), "sc_"..string.lower(id))

			for param, tbl in pairs(params) do

				local conVar = "sc_"..string.lower(id).."_"..string.lower(param)
				local printName = socialcredit.Localize(param)
			
				if tbl.minValue == 0 && tbl.maxValue == 1 then
				
					checkBox(printName, conVar)
					continue
				
				end

				numSlider(printName, conVar, tbl.minValue, tbl.maxValue)
			
			end
		
		end
	
	end

	local ABOUT = vgui.Create("DPanel", SHEET)
	ABOUT:Dock(FILL)
	ABOUT:DockMargin(2, 2, 2, 2)
	ABOUT.Paint = emptyFunction
	SHEET:AddSheet(socialcredit.Localize("about"), ABOUT, "icon16/help.png")

	ABOUT.Title = vgui.Create("DLabel", ABOUT)
	ABOUT.Title:Dock(TOP)
	ABOUT.Title:DockMargin(2, 2, 2, 2)
	ABOUT.Title:SetFont("DermaLarge")
	ABOUT.Title:SetText("Social credit system "..socialcredit.Version)
	ABOUT.Title:SizeToContents()

	ABOUT.Source = vgui.Create("DButton", ABOUT)
	ABOUT.Source:Dock(TOP)
	ABOUT.Source:DockMargin(2, 2, 2, 2)
	ABOUT.Source:SetText("GitHub")
	ABOUT.Source:SetIcon("icon16/package_link.png")

	ABOUT.Source.DoClick = function()
	
		gui.OpenURL("https://github.com/Afireal/gmod-social-credit/")
	
	end

	ABOUT.License = vgui.Create("DButton", ABOUT)
	ABOUT.License:Dock(TOP)
	ABOUT.License:DockMargin(2, 2, 2, 2)
	ABOUT.License:SetText("Licence")
	ABOUT.License:SetIcon("icon16/page_white_key.png")

	ABOUT.License.DoClick = function()
	
		local FRAME = vgui.Create("DFrame")
		FRAME:SetSize(500, 300)
		FRAME:Center()
		FRAME:MakePopup()
		FRAME:SetTitle(menuTitle)
		FRAME:SetIcon("icon16/page_white_key.png")

		FRAME.Content = vgui.Create("RichText", FRAME)
		FRAME.Content:Dock(FILL)
		FRAME.Content:AppendText(license)
	
	end

	SCOREBOARD.List:Update()
	SETTINGS:Update()

end

list.Add("DesktopWindows", {

	title = menuTitle,
	icon = "icon64/tool.png",
	init = socialcredit.OpenMenu,
	onewindow = true,
	width = menuSize.w,
	height = menuSize.h

})
