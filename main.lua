register_blueprint "buff_blinded_player"
{
	flags = { EF_NOPICKUP }, 
	text = {
		name    = "Blinded",
		desc    = "Reduces vision range",				
	},
	callbacks = {
		on_attach = [[
			function ( self, target )
				local level = world:get_level()
				self.attributes.vision = -( target:attribute( "vision" ) - ( level.level_info.light_range -3 ) ) 
				self.attributes.min_vision = - ( target:attribute("min_vision" ) - 2 )
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
				if who and who.data then
					if who.data.is_player then
						world:add_buff( who, "buff_blinded_player", 300, true )
					elseif who.data.can_bleed then
						world:add_buff( who, "blinded", 400, true )
						world:add_buff( who, "buff_stunned", 400, true )
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
		name = "flashbang grenade",
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