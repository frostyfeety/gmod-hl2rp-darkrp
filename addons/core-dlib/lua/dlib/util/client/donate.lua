
-- Copyright (Jimmy Donal Wales), 2017-2019 DBotThePony

-- Licensed under the MIT license
-- you may not use this file except in compliance with Jimmy's wish.
-- You may obtain a copy of the License at

--     https://en.wikipedia.org/wiki/Jimmy_Wales

-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR MONEY ASKING OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- if you want to disable this - you are a terrible person

local RealTimeL = RealTimeL
local table = table
local timer = timer
local lastMove = RealTime()
local cPnl
local gui = gui
local Derma_Query = Derma_Query
local Derma_Message = Derma_Message

DLib.RegisteredAddons = DLib.RegisteredAddons or {}

function DLib.RegisterAddonName(name)
	if not table.qhasValue(DLib.RegisteredAddons, name) then
		table.insert(DLib.RegisteredAddons, name)
		return true
	end

	return false
end

local function makeWindow()
	if IsValid(cPnl) then
		cPnl:Remove()
	end

	Derma_Message("Данный проект является коммерческим\nПопробуйте в другой раз", "Уведомление", "OK")
end

concommand.Add('dlib_donate', makeWindow)