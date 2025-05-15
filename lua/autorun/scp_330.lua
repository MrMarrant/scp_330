-- SCP-330, A representation of a paranormal object on a fictional series on the game Garry's Mod.
-- Copyright (C) 2025 MrMarrant.

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

-- Functions
scp_330 = {}
-- Global Variable
SCP_330_CONFIG = {}
-- Lang
SCP_330_LANG = {}
-- Root path
SCP_330_CONFIG.RootFolder = "scp_330/"
-- Actual lang server
SCP_330_CONFIG.LangServer = GetConVar("gmod_language"):GetString()

/*
* Load the file set in the parameters.
* @string File The name of the file to load.
* @string directory The path of the directory to load.
*/
local function AddFile( File, directory )
	local prefix = string.lower( string.Left( File, 3 ) )

	if SERVER and prefix == "sv_" then
		include( directory .. File )
	elseif prefix == "sh_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
		end
		include( directory .. File )
	elseif prefix == "cl_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
		elseif CLIENT then
			include( directory .. File )
		end
	end
end

/*
* Allows you to load all the files in a folder.
* @string directory The path of the directory to load.
*/
local function LoadDirectory( directory )
	directory = directory .. "/"

	local files, directories = file.Find( directory .. "*", "LUA" )

	for _, v in ipairs( files ) do
		if string.EndsWith( v, ".lua" ) then
			AddFile( v, directory )
		end
	end

	for _, v in ipairs( directories ) do
		LoadDirectory( directory .. v )
	end
end

print("SCP-330 Loading . . .")
LoadDirectory(SCP_330_CONFIG.RootFolder .. "config")
LoadDirectory(SCP_330_CONFIG.RootFolder .. "language")
LoadDirectory(SCP_330_CONFIG.RootFolder .. "modules")
print("SCP-330 Loaded!")