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
minetest.register_craftitem("mypress:sheet_gold",{
	inventory_image = "mypress_sheet_gold.png",
	description = "Sheet Of Gold",
})

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
