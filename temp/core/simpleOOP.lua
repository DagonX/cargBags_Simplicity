--[[
	cargBags: An inventory framework addon for World of Warcraft

	Copyright (C) 2010  Constantin "Cargor" Schomburg <xconstruct@gmail.com>

	cargBags is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	cargBags is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with cargBags; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
	class-generation, helper-functions and the Blizzard-replacement.
]]

local addon, ns = ...
local SimpleOOP = {}
ns.SimpleOOP = SimpleOOP

local classes = {}
SimpleOOP.classes = classes

local Prototype = {}
SimpleOOP.Prototype = Prototype

local widgets = setmetatable({}, {__index = function(self, widget)
	self[widget] = getmetatable(CreateFrame(widget))
	return self[widget]
end})

--[[!
	Creates a new class
	-> name <string>
	-> parent <string> parent class [optional]
	-> widget <string> widget type [optional]
	<- class <Prototype>
]]
function SimpleOOP:New(name, parent, widget)
	if(classes[name]) then return end
	local class = {}
	class.__index = class

	if(parent) then
		parent = classes[parent]
		class._parent = parent
		setmetatable(class, parent)
	elseif(widget) then
		class._widgetName = widget
		widget = widgets[widget]
		class._widget = widget
		setmetatable(class, widget)
	end

	if(not parent) then
		for k,v in pairs(Prototype) do
			class[k] = v
		end
	end

	classes[name] = class

	return class
end

--[[!
	Fetches a class, if available
	-> name <string>
	<- class <Prototype, nil>
]]
function SimpleOOP:Get(name)
	return classes[name]
end

--[[!
	Creates a new instance of this class
	-> ... arguments passed to CreateFrame(X, ...) [optional]
	<- instance <Instance>
]]
function Prototype:NewInstance(...)
	local instance = self._widgetName and CreateFrame(self._widgetName, ...) or {}
	return setmetatable(instance, self.__index)
end

local handlerFuncs = setmetatable({}, {__index=function(self, handler)
	self[handler] = function(self, ...) return self[handler] and self[handler](self, ...) end
	return self[handler]
end})

--[[!
	Sets a row of script handlers, directing them to functions
	-> ... <string> names of script handlers to set
]]
function Prototype:SetScriptHandlers(...)
	for i=1, select("#", ...) do
		local handler = select(i, ...)
		self:SetScript(handler, handlerFuncs[handler])
	end
end
