-- ####################################################################################
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     CASUAL BANANAS CONFIDENTIAL                                                ##
-- ##                                                                                ##
-- ##     __________________________                                                 ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Copyright 2014 (c) Casual Bananas                                          ##
-- ##     All Rights Reserved.                                                       ##
-- ##                                                                                ##
-- ##     NOTICE:  All information contained herein is, and remains                  ##
-- ##     the property of Casual Bananas. The intellectual and technical             ##
-- ##     concepts contained herein are proprietary to Casual Bananas and may be     ##
-- ##     covered by U.S. and Foreign Patents, patents in process, and are           ##
-- ##     protected by trade secret or copyright law.                                ##
-- ##     Dissemination of this information or reproduction of this material         ##
-- ##     is strictly forbidden unless prior written permission is obtained          ##
-- ##     from Casual Bananas                                                        ##
-- ##                                                                                ##
-- ##     _________________________                                                  ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Casual Bananas is registered with the "Kamer van Koophandel" (Dutch        ##
-- ##     chamber of commerce) in The Netherlands.                                   ##
-- ##                                                                                ##
-- ##     Company (KVK) number     : 59449837                                        ##
-- ##     Email                    : info@casualbananas.com                          ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ####################################################################################


local color_text = Color(223,223,223,230);
local matGradient = Material("materials/jailbreak_excl/gradient.png"); 
local frame;

local slide_cur = 1;
local guide_slides={
	Material("jailbreak_excl/guide/slide_1.png"),
	Material("jailbreak_excl/guide/slide_2.png"),
	Material("jailbreak_excl/guide/slide_3.png"),
	Material("jailbreak_excl/guide/slide_4.png"),
}

function JB.MENU_HELP_OPTIONS()
	if IsValid(frame) then frame:Remove() end
	
	frame = vgui.Create("JB.Frame");
	frame:SetTitle("INFORMATION & OPTIONS");
	
	frame:SetWide(740);

	local right = frame:Add("JB.Panel");
	local left = frame:Add("JB.Panel");

	left:SetWide(math.Round(frame:GetWide() * .25) - 15);
	right:SetWide(math.Round(frame:GetWide() * .75) - 15);

	local tall = right:GetWide() * .65;

	left:SetTall(tall); right:SetTall(tall);

	
	left:SetPos(10,40);
	right:SetPos(left:GetWide() + left.x + 10,40);

	left.Paint = function() end;
	
	frame:SetTall(math.Round(right:GetTall() + 50))

	/* Set up the menu options */
	local btn_guide = left:Add("JB.Button");
	btn_guide:SetSize(left:GetWide(),32);
	btn_guide:SetText("Guide")

	local btn_options = left:Add("JB.Button");
	btn_options:SetSize(left:GetWide(),32);
	btn_options:SetText("Options")
	btn_options.y = 40;

	local btn_logs = left:Add("JB.Button");
	btn_logs:SetSize(left:GetWide(),32);
	btn_logs:SetText("Logs")
	btn_logs.y = 80;

	local btn_credits = left:Add("JB.Button");
	btn_credits:SetSize(left:GetWide(),32);
	btn_credits:SetText("About")
	btn_credits.y = 120;
	

	/* set up right panel population for each button */
	btn_guide.OnMouseReleased = function()
		JB.Util.iterate(right:GetChildren()):Remove();

		slide_cur = 1;

		local controls=right:Add("Panel");
		controls:SetSize(80*2 + 40,32+80);
		controls:SetPos(right:GetWide()/2-controls:GetWide()/2,right:GetTall()-controls:GetTall())

			local go_left=controls:Add("JB.Button");
			go_left:SetSize(80,32);
			go_left:SetText("Previous");
			go_left:Dock(LEFT);
			local go_right=controls:Add("JB.Button");
			go_right:SetSize(80,32);
			go_right:SetText("Next");
			go_right:Dock(RIGHT);

		local slideshow=right:Add("DImage");
		slideshow:SetSize(512,128);
		slideshow:SetMaterial(guide_slides[1]);
		slideshow:SetPos((right:GetWide())/2 - slideshow:GetWide()/2,70)

		go_left.OnMouseReleased=function()
			slide_cur =slide_cur-1;
			if slide_cur <= 1 then
				go_left:SetVisible(false);
			else
				go_left:SetVisible(true);
			end
			go_right:SetVisible(true);
			slideshow:SetMaterial(guide_slides[slide_cur]);
		end
		go_right.OnMouseReleased=function()
			slide_cur =slide_cur+1;
			if slide_cur >= #guide_slides-1 then
				go_right:SetVisible(false);
			else
				go_right:SetVisible(true);
			end
			go_left:SetVisible(true);
			slideshow:SetMaterial(guide_slides[slide_cur]);
		end
		go_left:SetVisible(false);
		
	end


	btn_logs.OnMouseReleased = function()
		JB.Util.iterate(right:GetChildren()):Remove();

		local lbl=Label("Round logs",right);
		lbl:SetPos(20,20);
		lbl:SetFont("JBLarge");
		lbl:SizeToContents();
		lbl:SetColor(JB.Color.white);

		local scrollPanel = vgui.Create( "DScrollPanel", right )
		scrollPanel:SetSize( right:GetWide()-40, right:GetTall()-20-lbl.y-lbl:GetTall()-20 )
		scrollPanel:SetPos( 20, lbl.y + lbl:GetTall() + 20 )

		LocalPlayer():ConCommand("jb_logs_get");

		local logs_old = JB.ThisRound.Logs;
		hook.Add("Think","JB.Think._MENU_.CheckChangesToLogs",function()
			if not IsValid(scrollPanel) then
				hook.Remove("Think","JB.Think._MENU_.CheckChangesToLogs");
				return;
			end

			if logs_old != JB.ThisRound.Logs then
				hook.Remove("Think","JB.Think._MENU_.CheckChangesToLogs");

				local Panels = {};
				local pnl;
				for k,v in ipairs(JB.ThisRound.Logs)do
					if not pnl or not pnl.subject or pnl.subject != v.subject then
						pnl=vgui.Create("EditablePanel");
						table.insert(Panels,pnl);
						pnl.Paint = function(self,w,h)
							draw.RoundedBox(6,0,0,w,h-10,JB.Color["#111"]);
							draw.RoundedBox(4,1,1,w-2,h-10-2,JB.Color["#333"]);
							draw.RoundedBox(0,70- (60/2),1,60,h-2-10,JB.Color["#444"])
						end					
						pnl:SetWide(scrollPanel:GetWide());
						pnl.subject = v.subject;
					end

					local textPanel=vgui.Create("Panel",pnl);
					textPanel:SetWide(pnl:GetWide());
					textPanel.Paint = function(self,w,h)
						// time
						JB.Util.drawSimpleShadowText(v.time,"JBExtraSmall",10,h/2,JB.Color.white,0,1,1);

						// type
						JB.Util.drawSimpleShadowText(v.kind,"JBExtraSmall",70,h/2,JB.Color.white,1,1,1);

						//message
						local clr=JB.Color.white
						local x=70+(60/2)+10;
						//local w;
						for _,msg in pairs(v.message)do
							if type(msg)=="table" and msg.r and msg.g and msg.b then
								clr = msg;
							elseif type(msg)=="string" then
								msg=string.gsub(msg," ?%(STEAM_0:.-%)","");
								x=x+JB.Util.drawSimpleShadowText(msg,"JBExtraSmall",x,h/2,clr,0,1,1);
							end
						end
					end
					textPanel:SetTall(20);

					textPanel:Dock(TOP);
					textPanel:DockMargin(0,2,0,2);
				end

				for k,v in ipairs(Panels)do
					v:SetTall(#v:GetChildren() * 24 + 10);

					scrollPanel:AddItem(v);
					v:Dock(TOP);
				end
			end
		end)
	end

	btn_options.OnMouseReleased = function()
		JB.Util.iterate(right:GetChildren()):Remove();

		local lbl=Label("Options",right);
		lbl:SetPos(20,20);
		lbl:SetFont("JBLarge");
		lbl:SizeToContents();
		lbl:SetColor(JB.Color.white);

		local container=right:Add("Panel");
		container:SetSize(right:GetWide()-40,right:GetTall()-lbl:GetTall()-lbl.y-40);
		container:SetPos(20,lbl.y+lbl:GetTall()+20);
		for k,v in pairs{
			{"jb_cl_option_toggleaim","toggle","Toggle aim (default: Right Mouse)"},
			{"jb_cl_option_togglecrouch","toggle","Toggle crouch (default: CTRL)"},
			{"jb_cl_option_togglewalk","toggle","Toggle walk (default: ALT)"}
		} do
			local fragment=container:Add("Panel");
			fragment:SetSize(container:GetWide(),32);
			fragment:SetPos(0,(k-1)*32);

			local lbl=Label(v[3],fragment);
			lbl:SetFont("JBSmall");
			lbl:SizeToContents();
			lbl:SetPos(32,fragment:GetTall()/2-lbl:GetTall()/2);
			lbl:SetColor(color_text);

			local DermaCheckbox = vgui.Create( "DCheckBox",fragment )// Create the checkbox
			DermaCheckbox:SetPos( fragment:GetTall()/2 - DermaCheckbox:GetWide()/2,   fragment:GetTall()/2 - DermaCheckbox:GetTall()/2)// Set the position
			DermaCheckbox:SetConVar( v[1] )
		end
	end
	btn_credits.OnMouseReleased = function()
		local text = "Blah blah blah";

		JB.Util.iterate(right:GetChildren()):Remove();
		JB.Util.iterate{Label("About",right)}:SetPos(20,20):SetFont("JBLarge"):SizeToContents():SetColor(JB.Color.white);
		JB.Util.iterate{Label(text,right)}:SetPos(20,60):SetColor(color_text):SetFont("JBSmall"):SetSize(right:GetWide() - 40,280):SetWrap(true);
	end

	/* create the menu */
	frame:Center();
	frame:MakePopup();

	/* open a tab */

	btn_guide.OnMouseReleased();
end
														