local give = 0
local material = {}

minetest.register_node("mypress:cutter_top", {
--	description = "Cutter Machine Top",
	tiles = {
		"mypress_cutter_top_top.png",
		"mypress_cutter_top_front.png",
		"mypress_cutter_top_right.png",
		"mypress_cutter_top_left.png",
		"mypress_cutter_top_front.png^[transformFX",
		"mypress_cutter_top_front.png"
		},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "mypress:cutter",
	sunlight_propogates = true,
	groups = {cracky=2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.375, -0.25, 0.25, 0.0625, 0.5},
			{-0.25, -0.5, 0.25, 0.25, 0.0625, 0.5},
			{0.25, -0.1875, 0, 0.375, 0.5, 0.125},
		}
	},
	after_destruct = function(pos, oldnode)
		minetest.remove_node({x = pos.x, y = pos.y - 1, z = pos.z})
	end,
})

minetest.register_node("mypress:cutter", {
	description = "Cutter Machine",
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
	inventory_image = "mypress_cutter_inv.png",
	wield_image = "mypress_cutter_wield.png",
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
		minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z},{name = "mypress:cutter_top", param2=minetest.dir_to_facedir(placer:get_look_dir())});

	local meta = minetest.get_meta(pos);
			meta:set_string("owner",  (placer:get_player_name() or ""));
			meta:set_string("infotext",  "Cutter Machine (owned by " .. (placer:get_player_name() or "") .. ")");
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
    if fields.mak then
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local ingot_stack = inv:get_stack("ingot", 1)
        local res_stack = inv:get_stack("res", 1)

        local mat_tab = {
            {"mypress:sheet_copper", "copper_wire", 8},
            {"mypress:sheet_paper", "book", 1},
        }

        if ingot_stack and not ingot_stack:is_empty() then
            for _, mat in ipairs(mat_tab) do
                if ingot_stack:get_name() == mat[1] then
                    local mat_name = mat[2]
                    local amount = mat[3]
                    local smax = (res_stack:get_stack_max())

                    if res_stack == nil or res_stack:is_empty() or
                       (res_stack:get_name() == "mypress:" .. mat_name and
                        res_stack:get_count() + amount) then
                        if res_stack:get_count() >= smax then
                        	return
                        end

                        local added_item = inv:add_item("res", {name = "mypress:" .. mat_name, count = amount})

                        if added_item then
                            ingot_stack:take_item(1)
                            inv:set_stack("ingot", 1, ingot_stack)
                            break
                        end
                    else
                        return
                    end
                end
            end
        end
    end
end,
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

