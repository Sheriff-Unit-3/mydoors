local rotate_disallow = rawget(_G, "screwdriver") and screwdriver.disallow or nil
local doorcolors = {"white","red","black"}

local function add_door(col)
	core.register_node("my_future_doors:door1a_"..col, {
		description = "Door 1a",
		tiles = {
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col.."b.png",
			"myndoors_door1_"..col.."b.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {cracky = 3},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.4375, -0.5, -0.1875, 0.4375, 0.5, -0.0625},
				{-0.5,    -0.5, -0.5,   -0.4375, 0.5,  0.5},
				{ 0.4375, -0.5, -0.5,    0.5,    0.5,  0.5},
				{ 0.4375, -0.5,  0.5,    0.625,  0.5,  0.5625},
				{ 0.4375, -0.5, -0.5625, 0.625,  0.5, -0.5},
				{-0.625,  -0.5, -0.5625,-0.4375, 0.5, -0.5},
				{-0.625,  -0.5,  0.5,   -0.4375, 0.5,  0.5625},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.4375,   -0.5,   -0.1875,  0.4375, 1.5,   -0.0625}, --door
				{ 0.4375,   -0.5,   -0.5625,  0.625,  1.4375, 0.5625}, --right
				{-0.625,    -0.5,   -0.5625, -0.4375, 1.4375, 0.5625}, --left
				{-0.625,     1.4375,-0.5625,  0.625,  1.625,  0.5625}, --top
			}
		},
		on_rotate = rotate_disallow,
		on_place = function(itemstack, placer, pointed_thing)
			local pos1 = pointed_thing.above
			local pos2 = vector.add(pos1, {x=0,y=1,z=0})

			if not placer or not placer:is_player() then
				return
			end

			if not core.registered_nodes[core.get_node(pos1).name].buildable_to or
			   not core.registered_nodes[core.get_node(pos2).name].buildable_to then
				core.chat_send_player(placer:get_player_name(), "Not enough room")
				return
			end

			local player_name = placer:get_player_name()
			if core.is_protected(pos1, player_name) then
				core.record_protection_violation(pos1, player_name)
				return
			end
			if core.is_protected(pos2, player_name) then
				core.record_protection_violation(pos2, player_name)
				return
			end
			return core.item_place(itemstack, placer, pointed_thing)
		end,
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			local node = core.get_node(pos)
			core.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="my_future_doors:door1b_"..col, param2=node.param2})
		end,
		after_destruct = function(pos, oldnode)
			core.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="air"})
		end,
		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			if node.name == "my_future_doors:door1a_"..col then
				local timer = core.get_node_timer(pos)
				core.set_node(pos, {name="my_future_doors:door1c_"..col, param2=node.param2})
				core.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="my_future_doors:door1d_"..col, param2=node.param2})
				timer:start(3)
			end
		end,
	})
	core.register_node("my_future_doors:door1b_"..col, {
		tiles = {
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col.."b.png",
			"myndoors_door1_"..col.."b.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {cracky = 1},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.4375, -0.5,    -0.1875,  0.4375, 0.5,   -0.0625},
				{-0.5,    -0.5,    -0.5,    -0.4375, 0.5,    0.5},
				{ 0.4375, -0.5,    -0.5,     0.5,    0.5,    0.5},
				{ 0.4375, -0.5,     0.5,     0.625,  0.5,    0.5625},
				{ 0.4375, -0.5,    -0.5625,  0.625,  0.5,   -0.5},
				{-0.625,  -0.5,    -0.5625, -0.4375, 0.5,   -0.5},
				{-0.625,  -0.5,     0.5,    -0.4375, 0.5,    0.5625},
				{-0.5,     0.4375, -0.5,     0.5,    0.5,    0.5},
				{-0.625,   0.4375, -0.5625,  0.625,  0.625, -0.5},
				{-0.625,   0.4375,  0.5,     0.625,  0.625,  0.5625},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, -0.5, -0.5, -0.5},
			}
		},
		on_rotate = rotate_disallow,
	})
	core.register_node("my_future_doors:door1c_"..col, {
		tiles = {
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col.."b.png",
			"myndoors_door1_"..col.."b.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {cracky = 1},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,    -0.5, -0.5,    -0.4375, 0.5,  0.5},
				{ 0.4375, -0.5, -0.5,     0.5,    0.5,  0.5},
				{ 0.4375, -0.5,  0.5,     0.625,  0.5,  0.5625},
				{ 0.4375, -0.5, -0.5625,  0.625,  0.5, -0.5},
				{-0.625,  -0.5, -0.5625, -0.4375, 0.5, -0.5},
				{-0.625,  -0.5,  0.5,    -0.4375, 0.5,  0.5625},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ 0.4375, -0.5,    -0.5625,  0.625,  1.4375, 0.5625}, --right
				{-0.625,  -0.5,    -0.5625, -0.4375, 1.4375, 0.5625}, --left
				{-0.625,   1.4375, -0.5625,  0.625,  1.625,  0.5625}, --top
			}
		},
		drop = "my_future_doors:door1a_"..col,
		on_rotate = rotate_disallow,
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			local node = core.get_node(pos)
			local timer = core.get_node_timer(pos)
			core.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="my_future_doors:door1d_"..col, param2=node.param2})
			timer:start(3)
		end,
		after_destruct = function(pos, oldnode)
			core.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="air"})
		end,
		on_timer = function(pos, elapsed)
			local node = core.get_node(pos)
			core.set_node(pos, {name="my_future_doors:door1a_"..col, param2=node.param2})
			core.set_node(vector.add(pos, {x=0,y=1,z=0}), {name="my_future_doors:door1b_"..col, param2=node.param2})
		end,
	})
	core.register_node("my_future_doors:door1d_"..col, {
		tiles = {
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col..".png",
			"myndoors_door1_"..col.."b.png",
			"myndoors_door1_"..col.."b.png"
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {cracky = 1},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,    -0.5,    -0.5,    -0.4375, 0.5,    0.5},
				{ 0.4375, -0.5,    -0.5,     0.5,    0.5,    0.5},
				{ 0.4375, -0.5,     0.5,     0.625,  0.5,    0.5625},
				{ 0.4375, -0.5,    -0.5625,  0.625,  0.5,   -0.5},
				{-0.625,  -0.5,    -0.5625, -0.4375, 0.5,   -0.5},
				{-0.625,  -0.5,     0.5,    -0.4375, 0.4375, 0.5625},
				{-0.5,     0.4375, -0.5,     0.5,    0.5,    0.5},
				{-0.625,   0.4375, -0.5625,  0.625,  0.625, -0.5},
				{-0.625,   0.4375,  0.5,     0.625,  0.625,  0.5625},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, -0.5, -0.5, -0.5},
			}
		},
		on_rotate = rotate_disallow,
	})
	core.register_craft({
		output = "my_future_doors:door1a_"..col.." 1",
		recipe = {
			{"my_door_wood:wood_"..col, "wool:"..col, "my_door_wood:wood_"..col},
			{"wool:"..col, "my_door_wood:wood_"..col, "wool:"..col},
			{"my_door_wood:wood_"..col, "wool:"..col, "my_door_wood:wood_"..col}
		}
	})
end

for _,col in ipairs(doorcolors) do
	add_door(col)
end
