register_blueprint "buff_blinded_player"
{
	flags = { EF_NOPICKUP }, 
	text = {
		name    = "Blinded",
		desc    = "Reduces vision range",				
	},
	callbacks = {
		on_post_command = [[
			function ( self, actor, cmt, tgt, time )
				world:callback( self )
			end
		]],
		on_callback = [[
			function ( self )
				local target = ecs:parent( self )
				local level = world:get_level()
				if self.lifetime.time_left > 100 then				
					target.attributes.vision = level.level_info.light_range - 3
				else
					target.attributes.vision = level.level_info.light_range
				end	
				
			end
		]],
		on_die = [[
			function ( self )	
				world:mark_destroy( self )
			end
		]],
		on_enter_level = [[
			function ( self )			
				world:mark_destroy( self )
			end
		]],
	},
	ui_buff = {
		color = WHITE,		
		style = 1,
	},
	attributes = {		
	},
}

register_blueprint "buff_blinded_enemy"
{
	flags = { EF_NOPICKUP }, 
	text = {
		name    = "Blinded",
		desc    = "Reduces vision range",				
	},
	callbacks = {
		on_post_command = [[
			function ( self, actor, cmt, tgt, time )
				world:callback( self )
			end
		]],
		on_callback = [[
			function ( self )
				local target = ecs:parent( self )
				local level = world:get_level()
				if self.lifetime.time_left > 100 then							
					target.data.ai.aware = false
					target.data.ai.state = "idle"
					target.data.ai.smell = nil
					target.target.entity = nil				
					target.data.ai.idle_vision = 1
					target.data.ai.vision = 1
					if target.listen then						
						target.listen.active = false
					end
					
				else
					target.data.ai.idle_vision = level.level_info.light_range
					target.data.ai.vision = level.level_info.light_range
					target.listen.active = true
				end					
			end
		]],
		on_die = [[
			function ( self )	
				world:mark_destroy( self )
			end
		]],
		on_enter_level = [[
			function ( self )			
				world:mark_destroy( self )
			end
		]],
	},
	ui_buff = {
		color = WHITE,		
		style = 1,
	},
	attributes = {		
	},
}

register_blueprint "buff_stunned"
{
	flags = { EF_NOPICKUP }, 
	ui_buff = {
		color     = DARKGRAY,
		attribute = "display_value",
		priority  = 90,
		style     = 0,
	},
	text = {
		name    = "Stunned",
		desc    = "slows down movement by the given amount",
	},
	callbacks = {
		on_die = [[
			function ( self )
				world:mark_destroy( self )
			end
		]],
	},
	attributes = {
		display_value = -25,
		move_time     = 1.34, 
	},
}

register_blueprint "apply_flashbanged"
{
	callbacks = {
		on_damage = [[
			function ( unused, weapon, who, amount, source )
				if who and who.data and who.data.can_bleed then
					if who.data.is_player then
						world:add_buff( who, "buff_blinded_player", 500, true )
					else
						who.data.ai.aware = false
						who.data.ai.state = "idle"
						who.data.ai.smell = nil
						who.target.entity = nil
						world:add_buff( who, "buff_blinded_enemy", 500, true )
						world:add_buff( who, "buff_stunned", 500, true )
					end
				end
			end
		]],
	}
}

register_blueprint "flashbang_grenade"
{
	flags = { EF_ITEM, EF_CONSUMABLE }, 
	lists = {
		group    = "item",
		keywords = { "general", "ammo", "grenade" },
		weight   = 350,
		dmin     = 1,
		dmed     = 10,
	},
	text = {
		name = "Flashbang grenade",
		desc = "Security issue Flashbang grenade. Stuns and blinds living things.",
	},
	ascii     = {
		glyph     = "*",
		color     = BLUE,
	},
	ui_target = {
		type = "mortar",
	},
	attributes = {
		damage    = 5,		
		explosion = 3,
		opt_distance = 5,
		max_distance = 8,
	},
	weapon = {
		group = "grenades",
		type  = "mortar",
		damage_type = "impact",
	},
	stack = {
		max    = 3,
		amount = 1,
	},
	callbacks = {
		on_create = [=[
			function( self )
				self:attach( "apply_flashbanged" )
			end
		]=],
	},
}