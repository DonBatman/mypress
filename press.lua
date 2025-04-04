local give = 0
local material = {}

minetest.register_node("mypress:machine_top", {
--	description = "Press Machine Top",
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
	inventory_image = "mypress_press_inv.png",
	wield_image = "mypress_press_wield.png",
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
    if fields.mak then
        local mat_tab = {
            {"default:tin_ingot", "mypress:sheet_tin", 2},
            {"default:bronze_ingot", "mypress:sheet_bronze", 2},
            {"default:copper_ingot", "mypress:sheet_copper", 2},
            {"default:steel_ingot", "mypress:sheet_steel", 2},
            {"default:gold_ingot", "mypress:sheet_gold", 2},
            {"mystreets:ingot_lead", "mypress:sheet_lead", 2},
            {"mystreets:ingot_nickel", "mypress:sheet_nickel", 2},
            {"mystreets:ingot_zinc", "mypress:sheet_zinc", 2},
            {"myores:silver_ingot", "mypress:sheet_silver", 2},
            {"default:acacia_wood", "mypress:sheet_paper", 10},
            {"default:aspen_wood", "mypress:sheet_paper", 10},
            {"default:pine_wood", "mypress:sheet_paper", 10},
            {"default:wood", "mypress:sheet_paper", 10},
            {"default:cobble", "default:sand", 1},
            {"default:desert_cobble", "default:desert_sand", 1},
            {"default:stone", "default:sand", 1},
            {"default:cobble", "default:sand", 1},
            {"default:gravel", "default:sand", 1},
            {"default:coal_block", "default:diamond", 1},
            {"mycobble:desert_gravel", "default:desert_sand", 1},
            {"mycobble:sandstone_gravel", "mycobble:sandstone_sand", 1},
            {"mycobble:silver_gravel", "default:silver_sand", 1},
            {"mycobble:silver_cobble", "default:silver_sand", 1},
            {"mycobble:sandstone_cobble", "default:sandstone_sand", 1},
            {"mycobble:desert_sandstone_cobble", "mycobble:desert_sandstone_sand", 1},
            {"mycobble:desert_sandstone_gravel", "mycobble:desert_sandstone_sand", 1},
            {"flowers:chrysanthemum_green", "mypress:pressed_flower_green", 1},
            {"flowers:dandelion_white", "mypress:pressed_flower_white", 1},
            {"flowers:dandelion_yellow", "mypress:pressed_flower_yellow", 1},
            {"flowers:geranium", "mypress:pressed_flower_blue", 1},
            {"flowers:rose", "mypress:pressed_flower_red", 1},
            {"flowers:tulip", "mypress:pressed_flower_orange", 1},
            {"flowers:tulip_black", "mypress:pressed_flower_black", 1},
            {"flowers:viola", "mypress:pressed_flower_viola", 1},
            {"default:mese_crystal", "default:mese_crystal_fragment", 9},
            {"default:obsidian", "default:obsidian_shard", 9},
            {"default:chest", "mypress:wood_chunks", 5},
            {"default:chest_locked", "mypress:wood_chunks", 5},
            {"default:bookshelf", "mypress:wood_chunks", 5},
            {"default:fence_wood", "mypress:wood_chunks", 3},
            {"default:fence_acacia_wood", "mypress:wood_chunks", 3},
            {"default:fence_pine_wood", "mypress:wood_chunks", 5},
            {"default:fence_aspen_wood", "mypress:wood_chunks", 5},
            {"default:fence_junglewood", "mypress:wood_chunks", 5},
            {"default:furnace", "default:sand", 1},
            {"default:ladder_wood", "mypress:wood_chunks", 5},
            {"default:ladder_steel", "mypress:sheet_steel", 5},
            {"doors:door_wood", "mypress:wood_chunks", 5},
            {"default:door_steet", "mypress:sheet_steel", 5},
            {"farming:wheat", "farming:flour", 2},
            {"doors:trapdoor", "mypress:wood_chunks", 5},
            {"doors:trapdoor_steel", "mypress:sheet_steel", 5},
            {"doors:gate_wood_closed", "mypress:wood_chunks", 5},
            {"doors:gate_pine_wood_closed", "mypress:wood_chunks", 5},
            {"doors:gate_acacia_wood_closed", "mypress:wood_chunks", 5},
            {"doors:gate_aspen_wood_closed", "mypress:wood_chunks", 5},
            {"doors:gate_junglewood_closed", "mypress:wood_chunks", 5},
            {"vessels:shelf", "mypress:wood_chunks", 5},
            {"default:glass", "mypress:glass_pieces", 5},
            {"default:obsidian_glass", "mypress:glass_pieces", 5},
            {"doors:door_obsidian_glass", "mypress:glass_pieces", 5},
            {"doors:door_glass", "mypress:glass_pieces", 5},
            {"vessels:drinking_glass", "mypress:glass_pieces", 5},
            {"vessels:glass_bottle", "mypress:glass_pieces", 5},
            {"xpanes:obsidian_pane_flat", "mypress:glass_pieces", 5},
            {"xpanes:pane_flat", "mypress:glass_pieces", 5},
            {"myores:sodium_ingot", "myores:salt", 5},
            {"myores:calcium_ingot", "myores:calcium", 5},
            {"myores:chromium_ingot", "mypress:sheet_chromium", 5},
            {"myores:manganese_ingot", "mypress:sheet_manganese", 5},
        	}

        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local ingot_stack = inv:get_stack("ingot", 1)
        local res_stack = inv:get_stack("res", 1)

        if ingot_stack and not ingot_stack:is_empty() then
            for _, mat in ipairs(mat_tab) do
                if ingot_stack:get_name() == mat[1] then
                    local mat_name = mat[2]
                    local amount = mat[3]
                    local smax = (res_stack:get_stack_max())
                    if res_stack:is_empty() or (res_stack:get_count() + amount) then
                        if res_stack:get_count() >= smax then
                        	return
                        end
                        inv:add_item("res", {name = mat_name, count = amount})
                        ingot_stack:take_item(1)
                        inv:set_stack("ingot", 1, ingot_stack)
                        break
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

