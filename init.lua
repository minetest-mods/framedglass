-- Minetest 0.4.17 mod: framedglass

framedglass = {}

minetest.register_craft({
	output = 'framedglass:wooden_framed_glass 4',
	recipe = {
		{'default:glass', 'default:glass', 'default:stick'},
		{'default:glass', 'default:glass', 'default:stick'},
		{'default:stick', 'default:stick', ''},
	}
})

minetest.register_craft({
	output = 'framedglass:steel_framed_glass 4',
	recipe = {
		{'default:glass', 'default:glass', 'default:steel_ingot'},
		{'default:glass', 'default:glass', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', ''},
	}
})

minetest.register_craft({
	output = 'framedglass:wooden_framed_obsidian_glass 4',
	recipe = {
		{'default:obsidian_glass', 'default:obsidian_glass', 'default:stick'},
		{'default:obsidian_glass', 'default:obsidian_glass', 'default:stick'},
		{'default:stick', 'default:stick', ''},
	}
})

minetest.register_craft({
	output = 'framedglass:steel_framed_obsidian_glass 4',
	recipe = {
		{'default:obsidian_glass', 'default:obsidian_glass', 'default:steel_ingot'},
		{'default:obsidian_glass', 'default:obsidian_glass', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', ''},
	}
})

local sounds = minetest.get_modpath("default") and default.node_sound_glass_defaults()
local on_dig = minetest.get_modpath("unifieddyes") and unifieddyes.on_dig

minetest.register_node("framedglass:wooden_framed_glass", {
	description = "Wooden-framed Glass",
	drawtype = "glasslike_framed",
	tiles = {"framedglass_wooden_frame.png","framedglass_glass_face_streaks.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = sounds,
})

minetest.register_node("framedglass:steel_framed_glass", {
	description = "Steel-framed Glass",
	drawtype = "glasslike_framed",
	tiles = {"framedglass_steel_frame.png","framedglass_glass_face_streaks.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = sounds,
})

minetest.register_node("framedglass:wooden_framed_obsidian_glass", {
	description = "Wooden-framed Obsidian Glass",
	drawtype = "glasslike_framed",
	tiles = {"framedglass_wooden_frame.png","framedglass_glass_face_clean.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky=3},
	sounds = sounds,
})

local steel_framed_obsidian_glass = {
	description = "Steel-framed Obsidian Glass",
	drawtype = "glasslike_framed",
	tiles = {"framedglass_steel_frame.png", "framedglass_glass_face_clean.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	airbrush_replacement_node = "framedglass:steel_framed_obsidian_glass_tinted",
	groups = {cracky=3, ud_param2_colorable = 1},
	sounds = sounds,
	on_dig = on_dig,
}

local steel_framed_obsidian_glass_tinted = {
	description = "Steel-framed Obsidian Glass",
	drawtype = "glasslike_framed",
	tiles = {
		{ name = "framedglass_steel_frame.png", color = "white" },
		"framedglass_whiteglass.png",
	},
	inventory_image = minetest.inventorycube("framedglass_glass_face_inv_static.png"),
	paramtype = "light",
	paramtype2 = "color",
	sunlight_propagates = true,
	is_ground_content = false,
	use_texture_alpha = "blend",
	groups = {cracky=3, oddly_breakable_by_hand=3, ud_param2_colorable = 1, not_in_creative_inventory = 1},
	sounds = sounds,
	on_dig = on_dig,
}

if minetest.get_modpath("unifieddyes") then
	steel_framed_obsidian_glass.palette = "unifieddyes_palette_extended.png"
	steel_framed_obsidian_glass_tinted.palette = "unifieddyes_palette_extended.png"
end

minetest.register_node("framedglass:steel_framed_obsidian_glass", steel_framed_obsidian_glass)
minetest.register_node("framedglass:steel_framed_obsidian_glass_tinted", steel_framed_obsidian_glass_tinted)

-- crafts!

if minetest.get_modpath("unifieddyes") then
	unifieddyes.register_color_craft({
		output = "framedglass:steel_framed_obsidian_glass_tinted",
		type = "shapeless",
		palette = "extended",
		neutral_node = "framedglass:steel_framed_obsidian_glass",
		recipe = {
			"NEUTRAL_NODE",
			"MAIN_DYE"
		}
	})

	-- Convert old nodes

	local static_colors = {
		red         =  4*24     ,
		orange      =  4*24 +  2,
		yellow      =  4*24 +  4,
		green       =  4*24 +  8,
		cyan        =  4*24 + 12,
		blue        =  4*24 + 16,
		violet      =  4*24 + 18,
		magenta     =  4*24 + 20,
		darkgreen   =  8*24 +  8,
		pink        =         23,
		brown       =  8*24 +  2,
		white       = 10*24     ,
		grey        = 10*24 +  7,
		darkgrey    = 10*24 + 11,
		black       = 10*24 + 15
	}

	local old_nodes = {}
	for k in pairs(static_colors) do
		table.insert(old_nodes, "framedglass:steel_framed_obsidian_glass" .. k)
	end

	minetest.register_lbm({
		label = "Convert old framedglass static-colored nodes",
		name = "framedglass:convert_static",
		run_at_every_load = false,
		nodenames = old_nodes,
		action = function(pos, node)
			local oldcolor = string.sub(node.name, 40)
			if oldcolor then
				minetest.swap_node(pos, {
					name = "framedglass:steel_framed_obsidian_glass_tinted",
					param2 = static_colors[oldcolor]
				})
			else
				minetest.swap_node(pos, {
					name = "framedglass:steel_framed_obsidian_glass",
					param2 = 0
				})
			end
		end
	})
end

if minetest.get_modpath("mtt") and mtt.enabled then
	-- validate nodenames
	mtt.validate_nodenames(minetest.get_modpath("framedglass") .. "/nodenames.txt")
end

if core.get_modpath("mcl_core") then
	core.register_craft({
		output = 'framedglass:wooden_framed_glass 4',
		recipe = {
			{'mcl_core:glass', 'mcl_core:glass', 'mcl_core:stick'},
			{'mcl_core:glass', 'mcl_core:glass', 'mcl_core:stick'},
			{'mcl_core:stick', 'mcl_core:stick', ''},
		}
	})

	core.register_craft({
		output = 'framedglass:steel_framed_glass 4',
		recipe = {
			{'mcl_core:glass', 'mcl_core:glass', 'mcl_core:iron_ingot'},
			{'mcl_core:glass', 'mcl_core:glass', 'mcl_core:iron_ingot'},
			{'mcl_core:iron_ingot', 'mcl_core:iron_ingot', ''},
		}
	})

	core.register_craft({
		output = 'framedglass:wooden_framed_obsidian_glass 4',
		recipe = {
			{'mcl_core:glass', 'mcl_core:obsidian', 'mcl_core:stick'},
			{'mcl_core:obsidian', 'mcl_core:glass', 'mcl_core:stick'},
			{'mcl_core:stick', 'mcl_core:stick', ''},
		}
	})

	core.register_craft({
		output = 'framedglass:steel_framed_obsidian_glass 4',
		recipe = {
			{'mcl_core:glass', 'mcl_core:obsidian', 'mcl_core:iron_ingot'},
			{'mcl_core:obsidian', 'mcl_core:glass', 'mcl_core:iron_ingot'},
			{'mcl_core:iron_ingot', 'mcl_core:iron_ingot', ''},
		}
	})
end
