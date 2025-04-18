local give = 0
local material = {}

minetest.register_node("mypress:machine_top", {
	description = "Press Machine Top",
	tiles = {
		"mypress_machine_top_top.png",
		"mypress_machine_top_bottom.png^[transformR180",
		"mypress_machine_top_sides.png",
		"mypress_machine_top_sides.png^[transformFX",
		"mypress_machine_top_top.png",
		"mypress_machine_top_front.png"
		},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "mypress:machine",
	sunlight_propogates = true,
	groups = {cracky=2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.1875, 0, 0.1875, 0.3125, 0.1875},
			{-0.25, -0.5, 0.3125, 0.25, 0.3125, 0.5},
			{-0.25, 0.3125, -0.125, 0.25, 0.5, 0.5},
			{-0.125, -0.1875, -0.0625, 0.125, 0.3125, 0.25},
		}
	},
	after_destruct = function(pos, oldnode)
		minetest.remove_node({x = pos.x, y = pos.y - 1, z = pos.z})
	end,
})

minetest.register_node("mypress:machine", {
	description = "Press Machine",
	tiles = {
		"mypress_machine_bottom_top.png",
		"mypress_machine_bottom_bottom.png",
		"mypress_machine_bottom_side.png",
		"mypress_machine_bottom_side.png",
		"mypress_machine_bottom_side.png",
		"mypress_machine_bottom_front.png"
		},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
--	inventory_image = "mypress_mach_inv.png",
	groups = {cracky=2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.375, -0.375, -0.375},
			{0.375, -0.5, -0.5, 0.5, -0.375, -0.375},
			{-0.5, -0.5, 0.375, -0.375, -0.375, 0.5},
			{0.375, -0.5, 0.375, 0.5, -0.375, 0.5},
			{-0.5, -0.375, -0.5, 0.5, 0.5, 0.5},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 1.5, 0.5},
		}
	},

    on_place = function(itemstack, placer, pointed_thing)
        local pos = pointed_thing.above
        if minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name ~= "air" then
            minetest.chat_send_player( placer:get_player_name(), "Not enough space to place this!" )
            return
        end
        return minetest.item_place(itemstack, placer, pointed_thing)
    end,

	after_destruct = function(pos, oldnode)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
	end,

	after_place_node = function(pos, placer)
		minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z},{name = "mypress:machine_top", param2=minetest.dir_to_facedir(placer:get_look_dir())});

	local meta = minetest.get_meta(pos);
			meta:set_string("owner",  (placer:get_player_name() or ""));
			meta:set_string("infotext",  "Press Machine (owned by " .. (placer:get_player_name() or "") .. ")");
		end,
	after_destruct = function(pos, oldnode)
		minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z},{name = "air"})
	end,
can_dig = function(pos,player)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	if inv:is_empty("ingot") and
	   inv:is_empty("res") then
		return true
	else
	return false
	end
end,

on_construct = function(pos)
	local meta = minetest.get_meta(pos)
	meta:set_string("formspec", "size[8,9;]"..
		"background[-0.15,-0.25;8.40,9.75;mypress_background.png;]"..
		
		"label[2,0.5;Put in an item and press the button]"..
		
		"label[2,2.5;Input:]"..
		"list[current_name;ingot;2,3;1,1;]"..
		
		"button[3.5,3;1,1;mak;Make]"..
		
		"label[5,2.5;Output:]"..
		"list[current_name;res;5,3;1,1;]"..

		"list[current_player;main;0,5;8,4;]")
		
	meta:set_string("infotext", "Press Machine")
	local inv = meta:get_inventory()
	inv:set_size("ingot", 1)
	inv:set_size("res", 1)
end,

on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local ingot_stack = inv:get_stack("ingot", 1)
        local res_stack = inv:get_stack("res", 1)
        local give = false

        local mat_tab = {
            {"default:tin_ingot", "tin"},
            {"default:bronze_ingot", "bronze"},
            {"default:copper_ingot", "copper"},
            {"default:steel_ingot", "steel"},
            {"default:gold_ingot", "gold"},
            {"mystreets:ingot_lead", "lead"},
            {"mystreets:ingot_nickel", "nickel"},
            {"mystreets:ingot_zinc", "zinc"},
        }

        for _, mat in ipairs(mat_tab) do
            if ingot_stack:get_name() == mat[1] then
                give = true
                local mat_name = mat[2]
                if give then
                    inv:add_item("res", "mypress:sheet_" .. mat_name)
                    ingot_stack:take_item()
                    inv:set_stack("ingot", 1, ingot_stack)
                    give = false
                    break
                end
            end
        end
    end
})








--Craft Machine

minetest.register_craft({
		output = 'mypress:machine',
		recipe = {
			{'', 'group:wood', ''},
			{'default:steel_ingot', 'group:wood', 'default:steel_ingot'},
			{'', "group:wood", ''},		
		},
})

