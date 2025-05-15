-- SCP-330, A representation of a paranormal object on a fictional series on the game Garry's Mod.
-- Copyright (C) 2025  MrMarrant aka BIBI.

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

local LANG_EN = {
    warningsettings = "Only Super Admins can change these values, all other roles will do nothing.",
    adminaccess = "You need to be Admin or Super Admin to access this menu.",
    radius_effect = "Radius effect of the text message display at player to warning them.",
    bleed_delay = "Defined every x seconds, bleeding damage is applied.",
    bleed_duration = "Define how long the bleeding will last in seconds.",
    bleed_damage = "Define the damage to apply when player bleed.",

    pick_candy = "You took a SCP-330 candy with the scent of ",
    eat_candy = "You eat the candy with the taste of ",
    proximity_effect_01 = "take no more than two,",
    proximity_effect_02 = "please!!",
}

scp_330.AddLanguage("en", LANG_EN)