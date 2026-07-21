local rotate_simple = rawget(_G, "screwdriver") and screwdriver.rotate_simple or nil

local doorcol = {
	{"white",	"White",	"^[colorize:white:120", "my_door_wood:wood_white"},
	{"red",		"Red",		"^[colorize:red:120", "my_door_wood:wood_red"},
	{"black",	"Black",	"^[colorize:black:220", "my_door_wood:wood_black"},
	{"brown",	"Brown",	"^[colorize:black:180", "my_door_wood:wood_brown"},
	{"grey",	"Grey",		"^[colorize:white:120^[colorize:black:120", "my_door_wood:wood_grey"},
	{"dark_grey",	"Dark grey",	"^[colorize:white:120^[colorize:black:200", "my_door_wood:wood_dark_grey"},
	{"yellow",	"Yellow",	"^[colorize:yellow:100", "my_door_wood:wood_yellow"},
}

local function add_door(col, des, tint, craft)
	core.register_node("my_saloon_doors:door1a_"..col, {
		description = des.." Saloon Door ",
		tiles = {"mydoors_saloon_bottom.png"..tint},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {choppy = 3},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,   -0.1875, -0.0625,  0,      0.75,   0.0625},
				{-0.5,    0.75,   -0.0625, -0.0625, 0.8125, 0.0625},
				{-0.5,    0.8125, -0.0625, -0.125,  0.875,  0.0625},
				{-0.5,    0.875,  -0.0625, -0.1875, 0.9375, 0.0625},
				{-0.5,    0.9375, -0.0625, -0.3125, 1,      0.0625},
				{-0,     -0.1875, -0.0625,  0.5,    0.75,   0.0625},
				{ 0.0625, 0.75,   -0.0625,  0.5,    0.8125, 0.0625},
				{ 0.125,  0.8125, -0.0625,  0.5,    0.875,  0.0625},
				{ 0.1875, 0.875,  -0.0625,  0.5,    0.9375, 0.0625},
				{ 0.3125, 0.9375, -0.0625,  0.5,    1,      0.0625},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.1875, -0.0625, 0.5, 1, 0.0625},
			}
		},
		on_rotate = rotate_simple,

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
		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			local timer = core.get_node_timer(pos)
			local par1 = node.param2
			local par2 = core.dir_to_facedir(player:get_look_dir())
			if par1 + par2 == 1 or
			   par1 + par2 == 3 or
			   par1 + par2 == 5 then
				par2 = par1
			end
			if node.name == "my_saloon_doors:door1a_"..col then
				core.set_node(pos, {name="my_saloon_doors:door1b_"..col, param2=par2})
				timer:start(3)
			end
		end,
	})
	core.register_node("my_saloon_doors:door1b_"..col, {
		tiles = {"mydoors_saloon_bottom.png^[transformFY"..tint},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {choppy = 1},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,   -0.1875, -0.0625, -0.375, 0.75,   0.5},
				{-0.5,    0.75,   -0.0625, -0.375, 0.8125, 0.4375},
				{-0.5,    0.8125, -0.0625, -0.375, 0.875,  0.375},
				{-0.5,    0.875,  -0.0625, -0.375, 0.9375, 0.3125},
				{-0.5,    0.9375, -0.0625, -0.375, 1,      0.1875},
				{ 0.375, -0.1875, -0.0625,  0.5,   0.75,   0.5},
				{ 0.375,  0.75,   -0.0625,  0.5,   0.8125, 0.4375},
				{ 0.375,  0.8125, -0.0625,  0.5,   0.875,  0.375},
				{ 0.375,  0.875,  -0.0625,  0.5,   0.9375, 0.3125},
				{ 0.375,  0.9375, -0.0625,  0.5,   1,      0.1875},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{0, 0, 0, 0, 0, 0},
			}
		},
		on_rotate = rotate_simple,
		on_timer = function(pos, elapsed)
			local node = core.get_node(pos)
			core.set_node(pos, {name="my_saloon_doors:door1a_"..col, param2=node.param2})
			-- core.set_node(vector.add(pos, {x=0,y=1,z=0}),{name="my_saloon_doors:door1b_"..col,param2=node.param2})
		end,
	})
	core.register_craft({
		output = "my_saloon_doors:door1a_"..col,
		recipe = {
			{"", "", ""},
			{craft, "", craft},
			{craft, craft, craft}
		}
	})
end

for _,door in ipairs(doorcol) do
	add_door(unpack(door))
end
