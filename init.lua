moreshelves = {}

minetest.register_node("moreshelves:empty", {
	description = "Empty Shelf",
	tiles = {"default_wood.png", "default_wood.png", "default_wood.png^moreshelves_empty.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	output = "moreshelves:empty",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"", "", ""},
		{"group:wood", "group:wood", "group:wood"}
	}
})

function moreshelves.register_shelf(node_name, node_description, texture, allow_put)
	minetest.register_node(":"..node_name, {
		description = node_description,
		tiles = {"default_wood.png", "default_wood.png", texture},
		is_ground_content = false,
		groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
		sounds = default.node_sound_wood_defaults(),
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", "size[8,7;]"..default.gui_bg..default.gui_bg_img..default.gui_slots
					.."list[context;shelf;0,0.3;8,2;]list[current_player;main;0,2.85;8,1;]list[current_player;main;0,4.08;8,3;8]"
					.."listring[context;shelf]listring[current_player;main]"..default.get_hotbar_bg(0,2.85))
			local inv = meta:get_inventory()
			inv:set_size("shelf", 8 * 2)
		end,
		can_dig = function(pos,player)
			local inv = minetest.get_meta(pos):get_inventory()
			return inv:is_empty("shelf")
		end,
		allow_metadata_inventory_put = function(pos, listname, index, stack)
			for _,v in ipairs(allow_put) do
				if v == "moreshelves:all" then
					return stack:get_count()
				elseif v:split(":")[1] == "group" and minetest.get_item_group(stack:get_name(), v:split(":")[2]) ~= 0 then
					return stack:get_count()
				elseif stack:get_name() == v then
					return stack:get_count()
				end
			end
			return 0
		end,
		on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name().." moves stuff around in "..node_name.." at "..minetest.pos_to_string(pos))
		end,
		on_metadata_inventory_put = function(pos, listname, index, stack, player)
			minetest.log("action", player:get_player_name().." places stuff in "..node_name.." at "..minetest.pos_to_string(pos))
		end,
		on_metadata_inventory_take = function(pos, listname, index, stack, player)
			minetest.log("action", player:get_player_name().." takes stuff from "..node_name.." at "..minetest.pos_to_string(pos))
		end,
		on_blast = function(pos)
			local drops = {}
			default.get_inventory_drops(pos, "shelf", drops)
			drops[#drops+1] = node_name
			minetest.remove_node(pos)
			return drops
		end
	})
end

moreshelves.register_shelf("moreshelves:apple_shelf", "Apple Shelf", "default_wood.png^moreshelves_apple.png", {"default:apple"})
moreshelves.register_shelf("moreshelves:bread_shelf", "Bread Shelf", "default_wood.png^moreshelves_bread.png", {"farming:bread"})
moreshelves.register_shelf("moreshelves:flower_shelf", "Flower Shelf", "default_wood.png^moreshelves_flower.png", {"group:flower"})
moreshelves.register_shelf("moreshelves:food_shelf", "Food Shelf", "default_wood.png^moreshelves_food.png", {"group:food"})

minetest.register_craft({
	output = "moreshelves:food_shelf",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:food", "group:food", "group:food"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

minetest.register_craft({
	output = "moreshelves:apple_shelf",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"default:apple", "default:apple", "default:apple"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

minetest.register_craft({
	output = "moreshelves:bread_shelf",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"farming:bread", "farming:bread", "farming:bread"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

minetest.register_craft({
	output = "moreshelves:flower_shelf",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:flower", "group:flower", "group:flower"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

minetest.override_item("default:apple", {groups = {food = 1, fleshy = 3, dig_immediate = 3, flammable = 2, leafdecay = 3, leafdecay_drop = 1}})
minetest.override_item("farming:bread", {groups = {food = 1}})
minetest.override_item("flowers:mushroom_brown", {groups = {food = 1, snappy = 3, attached_node = 1}})
