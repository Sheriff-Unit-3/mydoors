local rotate_disallow = rawget(_G, "screwdriver") and screwdriver.disallow or nil

local doors = {
	{"my_sliding_doors:door1a","my_sliding_doors:door1b","my_sliding_doors:door1c","my_sliding_doors:door1d","1","White"},
	{"my_sliding_doors:door2a","my_sliding_doors:door2b","my_sliding_doors:door2c","my_sliding_doors:door2d","2","Flower"},
	{"my_sliding_doors:door3a","my_sliding_doors:door3b","my_sliding_doors:door3c","my_sliding_doors:door3d","3","Framed"},
}

local function add_door(doora, doorb, doorc, doord, num, des)
	local function onplace(itemstack, placer, pointed_thing)
		local pos1 = pointed_thing.above
		local pos = pos1
		local pos2 = core.find_node_near(pos1, 1, {doora})
		local par = core.dir_to_facedir(placer:get_look_dir())
		local par2 = par + 2
		local above = vector.add(pos, {x=0,y=1,z=0})

		if not placer or not placer:is_player() then
			return
		end

		if not core.registered_nodes[core.get_node(pos).name].buildable_to or
		   not core.registered_nodes[core.get_node(above).name].buildable_to then
			core.chat_send_player(placer:get_player_name(), "Not enough room")
			return
		end

		local player_name = placer:get_player_name()
		if core.is_protected(pos, player_name) then
			core.record_protection_violation(pos, player_name)
			return
		end
		if core.is_protected(above, player_name) then
			core.record_protection_violation(above, player_name)
			return
		end

		if par2 == 4 then par2 = 0 end
		if par2 == 5 then par2 = 1 end
		if pos2 == nil then
			core.set_node(pos, {name=doora,param2=par})
			core.set_node(above, {name=doorb,param2=par})
		else
			core.set_node(pos, {name=doora.."2",param2=par2})
			core.set_node(above, {name=doorb.."2",param2=par2})
		end

		if not (core.settings:get_bool("creative_mode") or core.check_player_privs(placer:get_player_name(), {creative = true})) then
			itemstack:take_item()
		end
		return itemstack

	end

	local function afterdestruct(pos, oldnode)
		core.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="air"})
	end

	local function rightclick(pos, node, player, itemstack, pointed_thing)
		if node.name == doora then
			core.set_node(pos, {name=doorc, param2=node.param2})
			core.set_node(vector.add(pos, {x=0,y=1,z=0}), {name=doord, param2=node.param2})
		elseif node.name == doorc then
			core.set_node(pos, {name=doora, param2=node.param2})
			core.set_node(vector.add(pos, {x=0,y=1,z=0}), {name=doorb, param2=node.param2})
		end

		-- Open neighbouring doors
		for i=0,3 do
			local dir = core.facedir_to_dir(i)
			local neighbour_pos = vector.add(pos, dir)
			local neighbour_above = vector.add(neighbour_pos, {x=0,y=1,z=0})
			local neighbour = core.get_node(neighbour_pos)
			if neighbour.name == doora then
				core.set_node(neighbour_pos,   {name=doorc, param2=neighbour.param2})
				core.set_node(neighbour_above, {name=doord, param2=neighbour.param2})
			elseif neighbour.name == doora.."2" then
				core.set_node(neighbour_pos,   {name=doorc.."2", param2=neighbour.param2})
				core.set_node(neighbour_above, {name=doord.."2", param2=neighbour.param2})
			elseif neighbour.name == doorc then
				core.set_node(neighbour_pos,   {name=doora, param2=neighbour.param2})
				core.set_node(neighbour_above, {name=doorb, param2=neighbour.param2})
			elseif neighbour.name == doorc.."2" then
				core.set_node(neighbour_pos,   {name=doora.."2", param2=neighbour.param2})
				core.set_node(neighbour_above, {name=doorb.."2", param2=neighbour.param2})
			end
		end
	end

	local function afterplace(pos, placer, itemstack, pointed_thing)
		local node = core.get_node(pos)
		core.set_node(vector.add(pos, {x=0,y=1,z=0}), {name=doord,param2=node.param2})
	end

	core.register_node(doora, {
		description = des.." Sliding Door",
		inventory_image = "myjdoors_door"..num.."a_inv.png",
		wield_image = "myjdoors_door"..num.."a_inv.png",
		tiles = {
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_bottom.png^[transformFX",
			"myjdoors_door"..num.."a_bottom.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		groups = {choppy = 3, cracky = 3},
		node_box = {
			type = "fixed",
			fixed = {
				{ 0.375, -0.5,  0.1875,  0.5,   0.5,   0.0625},
				{-0.5,   -0.5,  0.1875, -0.375, 0.5,   0.0625},

				{-0.5,   -0.5,  0.1875,  0.5,  -0.375, 0.0625},
				{-0.5,   -0.5,  0.125,   0.5,   0.5,   0.145},

				{-0.625, -0.5, -0.0625, -0.5,   0.5,   0.0625},
				{-1.5,   -0.5, -0.0625, -1.375, 0.5,   0.0625},

				{-1.5,   -0.5, -0.0625, -0.5,  -0.375, 0.0625},
				{-1.5,   -0.5,  0,      -0.5,   0.5,   0.02},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-1.5, -0.5, -0.0625, -0.5, 1.5, 0.0625},
				{-0.5, -0.5,  0.0625,  0.5, 1.5, 0.1875}
			}
		},
		on_rotate = rotate_disallow,
		on_place = onplace,
		after_destruct = afterdestruct,
		on_rightclick = rightclick,
	})
	core.register_node(doorb, {
		tiles = {
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_top.png^[transformFX",
			"myjdoors_door"..num.."a_top.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		groups = {choppy = 1, cracky = 1},
		node_box = {
			type = "fixed",
			fixed = {
				{ 0.375, -0.5,  0.1875,  0.5,   0.5,   0.0625},
				{-0.5,   -0.5,  0.1875, -0.375, 0.5,   0.0625},

				{-0.5,    0.5,  0.1875,  0.5,   0.375, 0.0625},
				{-0.5,   -0.5,  0.125,   0.5,   0.5,   0.145},

				{-0.625, -0.5, -0.0625, -0.5,   0.5,   0.0625},
				{-1.5,   -0.5, -0.0625, -1.375, 0.5,   0.0625},

				{-1.5,    0.5, -0.0625, -0.5,   0.375, 0.0625},
				{-1.5,   -0.5,  0,      -0.5,   0.5,   0.02},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{0, 0, 0, 0, 0, 0},
			}
		},
		on_rotate = rotate_disallow,
	})
	core.register_node(doorc, {
		tiles = {
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_bottom.png^[transformFX",
			"myjdoors_door"..num.."a_bottom.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		drop = doora,
		groups = {choppy = 1, cracky = 1},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.625, -0.5,  0.1875, -0.5,   0.5,   0.0625},
				{-1.5,   -0.5,  0.1875, -1.375, 0.5,   0.0625},

				{-1.5,   -0.5,  0.1875, -0.5,  -0.375, 0.0625},
				{-1.5,   -0.5,  0.125,  -0.5,   0.5,   0.145},

				{-0.625, -0.5, -0.0625, -0.5,   0.5,   0.0625},
				{-1.5,   -0.5, -0.0625, -1.375, 0.5,   0.0625},

				{-1.5,   -0.5, -0.0625, -0.5,  -0.375, 0.0625},
				{-1.5,   -0.5,  0,      -0.5,   0.5,   0.02},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-1.5, -0.5, -0.0625, -0.5, 1.5, 0.1875}
			}
		},
		on_rotate = rotate_disallow,
		after_place_node = afterplace,
		after_destruct = afterdestruct,
		on_rightclick = rightclick,
	})
	core.register_node(doord, {
		tiles = {
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_top.png^[transformFX",
			"myjdoors_door"..num.."a_top.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		groups = {choppy = 1, cracky = 1},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.625, -0.5,  0.1875, -0.5,   0.5,   0.0625},
				{-1.5,   -0.5,  0.1875, -1.375, 0.5,   0.0625},

				{-1.5,    0.5,  0.1875, -0.5,   0.375, 0.0625},
				{-1.5,   -0.5,  0.125,  -0.5,   0.5,   0.145},

				{-0.625, -0.5, -0.0625, -0.5,   0.5,   0.0625},
				{-1.5,   -0.5, -0.0625, -1.375, 0.5,   0.0625},

				{-1.5,    0.5, -0.0625, -0.5,   0.375, 0.0625},
				{-1.5,   -0.5,  0,      -0.5,   0.5,   0.02},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{0, 0, 0, 0, 0, 0},
			}
		},
		on_rotate = rotate_disallow,
	})
	core.register_node("my_sliding_doors:jpanel"..num, {
		description = des.." Panel",
		inventory_image = "myjdoors_panel"..num.."_inv.png",
		wield_image = "myjdoors_panel"..num.."_inv.png",
		tiles = {
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_bottom.png",
			"myjdoors_door"..num.."a_bottom.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		groups = {choppy = 3, cracky = 3},
		node_box = {
			type = "fixed",
			fixed = {
				{ 0.375,  -0.5, -0.0625,  0.5,    0.5,   0.0625},
				{-0.5,    -0.5, -0.0625, -0.375,  0.5,   0.0625},
				{-0.5,    -0.5, -0.0625,  0.5,   -0.375, 0.0625},
				{-0.4375, -0.5,  0,       0.4375, 0.5,   0.02},
			}
		},
		selection_box = {type = "fixed", fixed = {{-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}}},
		collision_box = {type = "fixed", fixed = {{-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}}},
		on_rotate = rotate_disallow,

		on_place = function(itemstack, placer, pointed_thing)
			local p2 = core.dir_to_facedir(placer:get_look_dir())
			local pos = pointed_thing.above
			local pos2 = vector.add(pos, {x=0,y=1,z=0})
			local na = core.get_node(pos2)

			if not placer or not placer:is_player() then
				return
			end

			if not core.registered_nodes[core.get_node(pos).name].buildable_to or
			   not core.registered_nodes[na.name].buildable_to then
				core.chat_send_player(placer:get_player_name(), "Not enough room")
				return
			end

			local player_name = placer:get_player_name()
			if core.is_protected(pos, player_name) then
				core.record_protection_violation(pos, player_name)
				return
			end
			if core.is_protected(pos2, player_name) then
				core.record_protection_violation(pos2, player_name)
				return
			end

			if na.name == "air" then
				core.set_node(pos,  {name = "my_sliding_doors:jpanel"..num, param2 = p2})
				core.set_node(pos2, {name = "my_sliding_doors:jpanel_top"..num, param2 = p2})
			else
				return
			end

			if not (core.settings:get_bool("creative_mode") or core.check_player_privs(placer:get_player_name(), {creative = true})) then
				itemstack:take_item()
			end
			return itemstack
		end,
		on_destruct = function(pos)
			core.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="air"})
		end,
	})
	core.register_node("my_sliding_doors:jpanel_top"..num, {
		tiles = {
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_top.png",
			"myjdoors_door"..num.."a_top.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		drop = "",
		groups = {choppy = 3, cracky = 3},
		node_box = {
			type = "fixed",
			fixed = {
				{ 0.375,  -0.5, -0.0625,  0.5,    0.5,   0.0625},
				{-0.5,    -0.5, -0.0625, -0.375,  0.5,   0.0625},
				{-0.5,     0.5, -0.0625,  0.5,    0.375, 0.0625},
				{-0.4375, -0.5,  0,       0.4375, 0.5,   0.02},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{0, 0, 0, 0, 0, 0}
			}
		},
		on_rotate = rotate_disallow,
	})
	core.register_node("my_sliding_doors:jpanel_corner_"..num, {
		description = des.." Panel Corner",
		inventory_image = "myjdoors_panel"..num.."_corner_inv.png",
		wield_image = "myjdoors_panel"..num.."_corner_inv.png",
		tiles = {
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_bottom.png",
			"myjdoors_door"..num.."a_bottom.png",
			"myjdoors_door"..num.."a_bottom.png",
			"myjdoors_door"..num.."a_bottom.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		groups = {choppy = 3, cracky = 3},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.0625, -0.5, -0.5,     0.0625001,  0.5,  -0.375},
				{-0.5,    -0.5, -0.0625, -0.375,      0.5,   0.0625},
				{-0.5,    -0.5, -0.0625,  0.0624999, -0.375, 0.0625},
				{-0.5,    -0.5,  0,       0,          0.5,   0.02},
				{-0.0625, -0.5, -0.5,     0.0625,    -0.375, 0.0625},
				{ 0.02,   -0.5, -0.5,     0,          0.5,   0},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.0625, -0.5, -0.5,    0.0625, 1.5, 0},
				{-0.5,    -0.5, -0.0625, 0,      1.5, 0.0625},
			}
		},
		on_rotate = rotate_disallow,
		on_place = function(itemstack, placer, pointed_thing)
			local p2 = core.dir_to_facedir(placer:get_look_dir())
			local pos = pointed_thing.above
			local pos2 = vector.add(pos, {x=0,y=1,z=0})
			local na = core.get_node(pos2)

			if not placer or not placer:is_player() then
				return
			end

			if not core.registered_nodes[core.get_node(pos).name].buildable_to or
			   not core.registered_nodes[na.name].buildable_to then
				core.chat_send_player(placer:get_player_name(), "Not enough room")
				return
			end

			local player_name = placer:get_player_name()
			if core.is_protected(pos, player_name) then
				core.record_protection_violation(pos, player_name)
				return
			end
			if core.is_protected(pos2, player_name) then
				core.record_protection_violation(pos2, player_name)
				return
			end

			if na.name == "air" then
				core.set_node(pos,  {name = "my_sliding_doors:jpanel_corner_"..num, param2 = p2})
				core.set_node(pos2, {name = "my_sliding_doors:jpanel_corner_top"..num, param2 = p2})
			else
				return
			end

			if not (core.settings:get_bool("creative_mode") or core.check_player_privs(placer:get_player_name(), {creative = true})) then
				itemstack:take_item()
			end
			return itemstack
		end,
		on_destruct = function(pos)
			core.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="air"})
		end,
	})
	core.register_node("my_sliding_doors:jpanel_corner_top"..num, {
		tiles = {
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_edge.png",
			"myjdoors_door"..num.."a_top.png",
			"myjdoors_door"..num.."a_top.png",
			"myjdoors_door"..num.."a_top.png",
			"myjdoors_door"..num.."a_top.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		drop = "",
		groups = {choppy = 3, cracky = 3},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.0625, -0.5,   -0.5,     0.0625001, 0.5, -0.375},
				{-0.5,    -0.5,   -0.0625, -0.375,     0.5,  0.0625},
				{-0.5,     0.375, -0.0625,  0.0625,    0.5,  0.0625},
				{-0.5,    -0.5,    0,       0,         0.5,  0.02},
				{-0.0625,  0.375, -0.5,     0.0625,    0.5,  0.0625},
				{ 0.02,   -0.5,   -0.5,     0,         0.5,  0},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{0, 0, 0, 0, 0, 0}
			}
		},
		on_rotate = rotate_disallow,
	})
end

for _,door in ipairs(doors) do
	add_door(unpack(door))
end

-- jpanel
core.register_craft({
	output = "my_sliding_doors:jpanel1",
	recipe = {
		{"group:stick", "default:paper", ""},
		{"group:stick", "default:paper", ""},
		{"group:stick", "default:paper", ""}
	}
})

core.register_craft({
	output = "my_sliding_doors:jpanel2",
	recipe = {
		{"group:stick", "default:paper", ""},
		{"group:stick", "default:paper", "flowers:rose"},
		{"group:stick", "default:paper", ""}
	}
})

core.register_craft({
	output = "my_sliding_doors:jpanel3",
	recipe = {
		{"group:stick", "default:paper", ""},
		{"group:stick", "default:paper", "group:stick"},
		{"group:stick", "default:paper", ""}
	}
})

-- jpanel_corner
core.register_craft({
	output = "my_sliding_doors:jpanel_corner_1",
	recipe = {
		{"my_sliding_doors:jpanel1"}
	}
})

core.register_craft({
	output = "my_sliding_doors:jpanel_corner_2",
	recipe = {
		{"my_sliding_doors:jpanel2"}
	}
})

core.register_craft({
	output = "my_sliding_doors:jpanel_corner_3",
	recipe = {
		{"my_sliding_doors:jpanel3"}
	}
})

-- double door
core.register_craft({
	output = "my_sliding_doors:door1a",
	recipe = {
		{"my_sliding_doors:jpanel1", "my_sliding_doors:jpanel1"}
	}
})

core.register_craft({
	output = "my_sliding_doors:door2a",
	recipe = {
		{"my_sliding_doors:jpanel2", "my_sliding_doors:jpanel2"}
	}
})

core.register_craft({
	output = "my_sliding_doors:door3a",
	recipe = {
		{"my_sliding_doors:jpanel3", "my_sliding_doors:jpanel3"}
	}
})