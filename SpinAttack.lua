LUAGUI_NAME = "Spin Attack"
LUAGUI_AUTH = "Zurphing"
LUAGUI_DESC = "Rotate your control stick or the D-Pad to activate a spin attack. You'll only have one second to activate it before you lose it!"

Timer = 70
local Down = false
local Up = false
local Right = false
local Left = false
function _OnInit()
    if GAME_ID == 0x431219CC and ENGINE_TYPE == "BACKEND" then
        ConsolePrint('PC version detected. Running script.')
		Btl0 = 0x2A74880-0x56454E --Btlbin
    end
end

function _OnFrame()
ReadInput = ReadShort(0x1ACF3C)
ReadStick = ReadByte(0x29F89F0-0x56454E) --Stick reads in 10 byte intervals. 
--Counterclockwise: 16 -> 64 -> 32 -> 128.
	if ReadStick == 16 and Up == false then
		Up = true
		--ConsolePrint("DEBUG: Up direction")
	end
	if ReadStick == 64 and Left == false then
		Left = true
		--ConsolePrint("DEBUG: Left direction")
	end
	if ReadStick == 32 and Right == false then
		Right = true
		--ConsolePrint("DEBUG: Right direction")
	end
	if ReadStick == 128 and Down == false then
		Down = true
		--ConsolePrint("DEBUG: Down direction")
	end
	if Up == true and Down == true and Left == true and Right == true and ReadByte(Btl0+0x202A9) ~= 3 then
		Spin = true
		WriteByte(Btl0+0x202A9, 3) --Vicinity Break: Type
		WriteByte(Btl0+0x202E8, 0) --Vicinity Break: Ability Required
	end
	if Spin == true and ReadInput & 16384 == 16384 then
		--ConsolePrint("DEBUG: Spin Attack Activated!")
		Up = false
		Left = false
		Right = false
		Spin = false
		WriteByte(Btl0+0x202A9, 2) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x202E8, 180) --Return Vicinity Break to requiring an ability.
	end
	if ReadByte(Btl0+0x202A9) == 3 then
		Timer = Timer - 1
		if Timer == 0 then
			Timer = 70 
			WriteByte(Btl0+0x202A9, 2)
			WriteByte(Btl0+0x202E8, 180)
			Up = false
			Down = false
			Left = false
			Right = false
			Spin = false
		end
	end
end