-- Made by ikefi - http://steamcommunity.com/id/ikefi/ --

aCrashScreen = aCrashScreen or {}
local _this = aCrashScreen
_this.config = _this.config or {}

-- Change this to false if you want to see proper error messages
-- and or if you're editing files with it automaticaly refreshing
-- If you're not or finished doing so change it back to true

if SERVER then
	
	AddCSLuaFile( 'lib/cl_protected_include.lua' )
	
	include( 'lib/sv_protected_include.lua' )
	
	_this.include.includeFile( 'acrashscreen/incl/sv_main.lua' )
	
	_this.include.includeFile( 'acrashscreen/cl_config.lua', true )
	_this.include.includeFile( 'acrashscreen/incl/cl_menu.lua' )
	_this.include.includeFile( 'acrashscreen/incl/cl_chat.lua' )
	_this.include.includeFile( 'acrashscreen/incl/cl_main.lua' )
	_this.include.includeFile( 'acrashscreen/incl/cl_web.lua' )
	_this.include.includeFile( 'acrashscreen/incl/cl_misc.lua' )
	
else
	
	include( 'lib/cl_protected_include.lua' )
	
end