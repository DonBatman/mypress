--Sheets Of Pressed Ingot
minetest.register_craftitem("mypress:sheet_tin",{
	inventory_image = "mypress_sheet_tin.png",
	description = "Sheet Of Tin",
})
minetest.register_craftitem("mypress:sheet_bronze",{
	inventory_image = "mypress_sheet_bronze.png",
	description = "Sheet Of Bronze",
})
minetest.register_craftitem("mypress:sheet_copper",{
	inventory_image = "mypress_sheet_copper.png",
	description = "Sheet Of Copper",
})
minetest.register_craftitem("mypress:sheet_steel",{
	inventory_image = "mypress_sheet_steel.png",
	description = "Sheet Of Steel",
})
minetest.register_craftitem("mypress:sheet_silver",{
	inventory_image = "mypress_sheet_silver.png",
	description = "Sheet Of Silver",
})
minetest.register_craftitem("mypress:sheet_gold",{
	inventory_image = "mypress_sheet_gold.png",
	description = "Sheet Of Gold",
})
minetest.register_craftitem("mypress:sheet_chromium",{
	inventory_image = "mypress_sheet_chromium.png",
	description = "Sheet Of Chromium",
})
minetest.register_craftitem("mypress:sheet_manganese",{
	inventory_image = "mypress_sheet_manganese.png",
	description = "Sheet Of Manganese",
})
minetest.register_craftitem("mypress:sheet_paper",{
	inventory_image = "mypress_paper.png",
	description = "Sheet Of Paper",
})
minetest.register_craftitem("mypress:book",{
	inventory_image = "mypress_book.png",
	description = "Book",
})
minetest.register_craftitem("mypress:copper_wire",{
	inventory_image = "mypress_copper_wire.png",
	description = "Copper Wire",
})
minetest.register_craftitem("mypress:wood_chunks",{
	inventory_image = "mypress_wood_trash.png",
	description = "Wood Chunks",
})
minetest.register_craftitem("mypress:glass_pieces",{
	inventory_image = "mypress_glass_trash.png",
	description = "Glass Pieces",
})

local flowers = {
				{"green","Green"},
				{"red","Red"},
				{"orange","Orange"},
				{"yellow","Yellow"},
				{"black","Black"},
				{"white","White"},
				{"blue","Blue"},
				{"viola","Viola"},
				}
for i in ipairs(flowers) do
	local col = flowers[i][1]
	local des = flowers[i][2]

minetest.register_craftitem("mypress:pressed_flower_"..col,{
	inventory_image = "mypress_pressed_flower_"..col..".png",
	description = des.." Pressed Flower",
})
minetest.register_node("mypress:framed_pressed_flower_"..col,{
	inventory_image = "mypress_picture_frame.png^mypress_pressed_flower_"..col..".png",
	description = des.." Pressed Flower Picture",
		tiles = {
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"mypress_picture_frame.png^mypress_pressed_flower_"..col..".png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 2, choppy = 2, not_in_creative_inventory=0, flammable = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
			}
		},
})
minetest.register_craft({
	output = "mypress:framed_pressed_flower_"..col.." 1",
	recipe = {
				{"default:stick","default:stick","default:stick"},
				{"default:stick","mypress:pressed_flower_"..col,"default:stick"},
				{"default:stick","default:stick","default:stick"}
				}
})
end

if minetest.get_modpath("mystreets") then
		minetest.register_craftitem("mypress:sheet_lead",{
			inventory_image = "mypress_sheet_lead.png",
			description = "Sheet Of Lead",
		})
		minetest.register_craftitem("mypress:sheet_nickel",{
			inventory_image = "mypress_sheet_nickel.png",
			description = "Sheet Of Nickel",
		})
		minetest.register_craftitem("mypress:sheet_zinc",{
			inventory_image = "mypress_sheet_zinc.png",
			description = "Sheet Of Zinc",
		})
end















