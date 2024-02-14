local PLUGIN = PLUGIN
PLUGIN.name = "Staz HUD"
PLUGIN.author = "staz"
PLUGIN.description = "Sadece hud."

ix.option.Add("HUD Kapat", ix.type.bool, false, {
	category = "Staz HUD"
})

if CLIENT then
    local color_white = Color(255, 255, 255)

    surface.CreateFont( "new", {
        font = "Roboto Medium Italic",
        size = 20,
        weight = 100,
        antialias = true,
    } )

    surface.CreateFont( "new2", {
        font = "Roboto Medium",
        size = 20,
        weight = 400,
        antialias = true,
    } )


    function PLUGIN.DrawTextRect(mat, x, y, w, h)
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( mat ) 
        surface.DrawTexturedRect( x, y, w, h ) 
    end

    hook.Add("HUDPaint", "staz_hud", function()
		if not ix.option.Get("HUD Kapat", false) then
			local ply = LocalPlayer()
			local char = ply:GetCharacter()
			local scrw, scrh = ScrW(), ScrH()
			
			if !char then return end 
			if(!IsValid(ply)) then return end
			if(!ply:Alive()) then return end
			if(ply:GetNoDraw()) then return end
			
			local t = StormFox2.Time.Get()
			local st = math.floor(t / 60) -- 0 - 24
			local dk = math.floor(t - st * 60) -- 0 - 60

			if(st<10) then
				st="0"..st
			end

			if(dk<10) then
				dk="0"..dk
			end

			-- TIME
			draw.RoundedBox(8, scrw*.945, scrh*.015, scrw*.050, scrh*.035, Color(26,25,25, 150))
			draw.SimpleText(st .. ":" .. dk, "new2",scrw*.969, scrh*.020,Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		
			-- HUD
			local hp = ply:Health()
			local armor = ply:Armor()
			local thirst = ply:GetSaturation()
			local hunger = ply:GetSatiety()
			local stamina = ply:GetLocalVar("stm", 0)
			
			local boxh = scrh * 0.045
			local boxw = scrw * 0.095
			local hboxw = scrw * 0.035
			local hboxh = scrh * 0.062
			
			local hpbarchange = boxw * math.Clamp((hp / ply:GetMaxHealth()) , 0, 1 )
			local armorbarchange = boxw * math.Clamp((armor / ply:GetMaxArmor()) , 0, 1 )
			local hungerbarchange = hboxh * (hunger / 100)
			local thirstbarchange = hboxh * (thirst / 100)
			local staminabarchange = scrw*.035*  math.Clamp((stamina / 100) , 0, 1 )
			
			local healthicon = Material("staz/hud/healthicon.png")
			local shieldicon = Material("staz/hud/shieldicon.png")
			local hungericon = Material("staz/hud/hungericon.png")
			local thirsticon = Material("staz/hud/watericon.png")
			local staminaicon = Material("staz/hud/staminaicon.png")
			
			-- HP
			draw.RoundedBox( 3, scrw* 0.00258, scrh* 0.944, scrw* 0.098, scrh* 0.05, Color( 15, 15, 15, 150) )
			draw.RoundedBox( 3, scrw* 0.00473, scrh* 0.945, hpbarchange, boxh, Color( 48, 163, 113, 255 ) )
			
			-- ARMOR
			draw.RoundedBox( 3, scrw* 0.103, scrh* 0.944, scrw* 0.098, scrh* 0.05, Color( 15, 15, 15, 150) )
			draw.RoundedBox( 3, scrw* 0.1045, scrh* 0.945, armorbarchange, boxh, Color( 57, 138, 255, 255 ) )
			
			-- HUNGER
			draw.RoundedBox( 3, scrw* 0.203, scrh* 0.944, scrw* 0.038, scrh* 0.05, Color( 15, 15, 15, 150) )
			draw.RoundedBox( 3, scrw* 0.2045, scrh* 0.945, hungerbarchange, boxh, Color( 213, 153, 62, 255 ) )
					
			-- THIRST
			draw.RoundedBox( 3, scrw* 0.242, scrh* 0.944, scrw* 0.038, scrh* 0.05, Color( 15, 15, 15, 150) )
			draw.RoundedBox( 3, scrw* 0.244, scrh* 0.945, thirstbarchange, boxh, Color( 73, 121, 175, 255 ) )
			
			-- STAMINA
			draw.RoundedBox( 3, scrw* 0.282, scrh* 0.944, scrw* 0.038, scrh* 0.05, Color( 15, 15, 15, 150) )
			draw.RoundedBox( 3, scrw* 0.283, scrh* 0.945, staminabarchange, boxh, Color( 73, 90, 121, 255 ) )
					
			-- ICONS
			PLUGIN.DrawTextRect(healthicon,scrw*.014,scrh*.956, scrw*.015, scrh*.025)
			PLUGIN.DrawTextRect(shieldicon,scrw*.115,scrh*.958, scrw*.0135, scrh*.022)
			PLUGIN.DrawTextRect(hungericon,scrw*.215,scrh*.958, scrw*.0135, scrh*.022)
			PLUGIN.DrawTextRect(thirsticon,scrw*.255,scrh*.958, scrw*.0135, scrh*.022)
			PLUGIN.DrawTextRect(staminaicon,scrw*.295,scrh*.958, scrw*.0135, scrh*.022)
			
			draw.DrawText( "Staz Framework", "new", ScrW() * 0.945, ScrH() * 0.96, Color( 255, 255, 255, 150), TEXT_ALIGN_CENTER )
			
		else
		 return
		end
	end)
end

function PLUGIN:ShouldHideBars()
    return true
end