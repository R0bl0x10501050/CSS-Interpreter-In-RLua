--[[

	Copyright 2020, R0bl0x10501050. All rights reserved.

]]

-----------------------------------------------------------------------------------------------

local CSS = {}

function CSS.Run(text, filename)
	
	--------------------------------------
	-- REQUIRES --
	--------------------------------------
	
	-- local Try = require(987135020)
	
	--------------------------------------
	-- local functionINITIONS --
	--------------------------------------
	
	local TT_NAME		= '.'
	
	local TIER1KEYWORDS = {
		'ScreenGui',
		'Frame',
		'ScrollingFrame',
		'TextButton',
		'TextBox',
		'TextLabel',
		'ImageButton',
		'ImageLabel'
	}
	
	--------------------------------------
	-- INITIALIZATION --
	--------------------------------------
	
	local SourceScriptName
	local SourceScript
	
	--------------------
	
	local function len(str)
		return string.len(str)
	end
	
	local function toTable(str)
		local t = {}
		
		str:gsub(".", function(c)
			table.insert(t, c)
			return c
		end)
		
		return t
	end
	
	local function getAllElementsThatAre(elementName, parent)
		local returnTable = {}
		
		for i, v in pairs(parent:GetChildren()) do
			if v:IsA(elementName) then
				table.insert(returnTable, #returnTable + 1, v)
				getAllElementsThatAre(elementName, v)
			else 
				getAllElementsThatAre(elementName, v)
			end
		end
		
		return returnTable
	end
	
	local function getAllElementsNamed(name, parent)
		local returnTable = {}
		
		for i, v in pairs(parent:GetChildren()) do
			if v.Name == name then
				table.insert(returnTable, #returnTable + 1, v)
				getAllElementsNamed(name, v)
			else 
				getAllElementsNamed(name, v)
			end
		end
		
		return returnTable
	end
	
	local function getAllElements(parent)
		local returnTable = {}
		
		for i, v in pairs(parent:GetChildren()) do
			table.insert(returnTable, #returnTable + 1, v)
			getAllElements(v)
		end
		
		return returnTable
	end
	
	local function checkFileExists()
		local filenames = getAllElementsThatAre("Script", game)
		
		for i, v in ipairs(filenames) do
			if v.Name == filename then
				SourceScriptName = filename
				SourceScript = v
				return
			end
		end
		
		SourceScriptName = "UNDEFINED"
	end
	
	local function Execute(object, property, value)
		local try = pcall(function()
			if not object[property] then return nil end
			
			object[property] = value
			
			local childrenTable = getAllElements(object)
			
			for i, v in ipairs(childrenTable) do
				v[property] = value
			end
		end)
		
		if not try then
			print("ERROR: File " .. SourceScriptName .. ", when trying to set " .. value .. " to " .. property)
		end
	end
	
	local function Reader(text)
		local Tokens = toTable(text)
		local current_char = Tokens[1]
		local idx = 1
		
		---------------------------------------------------
		
		print(Tokens[1])
		
		---------------------------------------------------
		
		local function advance()
			
			idx += 1
			
			if idx < len(text) then 
				current_char = Tokens[idx]
				print(current_char)
			else
				current_char = nil
			end
		end
		
		---------------------------------------------------
		
		local function Interpret()
			local name
			local startStyle
			local endStyle
			
			print("Passed1")
			
			if current_char == ' \n' or current_char == ' \t' then
				advance()
			elseif current_char == '.' then
				local strName = ""
				
				repeat
					advance()
					strName = strName .. current_char
				until current_char == " \s"
				
				local name = strName
				
				local tableOfElements = getAllElementsNamed(name, game.StarterGui)
				
				repeat
					advance()
				until current_char == "{"
				
				repeat
					advance()
					
				until current_char == "}"
				
				--for i, keyword in ipairs(TIER1KEYWORDS) do
				--	if keyword == current_char then
				--		advance()
						
				--		if current_char == ": " then
				--			advance()
							
				--			if not current_char == '\n' then
				--				for i, v in ipairs(tableOfElements) do
				--					Execute(v, keyword, current_char)
				--					print("v: " .. v)
				--					print("keyword: " .. v)
				--					print("current_char: " .. v)
				--				end
				--			else
				--				print("Error2")
				--			end
				--		else
				--			print("Error1")
				--		end
				--	end
				--end
			end
		end
		
		---------------------------------------------------
		
		advance()
		
		while current_char ~= nil do
			Interpret()
		end
	end
	
	--------------------------------------
	-- RUN --
	--------------------------------------
	
	--checkFileExists()
	
	print("Text: " .. text)
	Reader(text)
end

return CSS