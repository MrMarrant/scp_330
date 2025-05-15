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