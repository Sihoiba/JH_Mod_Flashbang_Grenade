nova.require "data/lua/gfx/common"

register_gfx_blueprint "fx_on_hit_flashbang_grenade"
{
	blueprint = "ps_explosion_large",
	lifetime = {
		duration = 3.0,
	},
	light = {
		color       = vec4(3.0,3.0,3.0,2.0),
		range       = 5.0,
	},
	fade = {
		fade_out = 0.5,
	},
	camera_shake = {
		power 		= 0.22,
		duration 	= 0.35,
	},
	"ps_explosion_crater_small",
}

register_gfx_blueprint "flashbang_grenade"
{
	weapon_fx = {
		on_shot   = "fx_on_shot_grenade",
		on_hit    = "fx_on_hit_flashbang_grenade",
		velocity  = 8.0,
	},
	uisprite = {
		icon = "data/texture/ui/icons/ui_ammunition_grenade_2",
		color = vec4( 0.1, 0.1, 1.0, 1.0 ),
	},
	light = {
		position    = vec3(0,0.1,0),
		color       = vec4(0.2,0.2,1,1),
		range       = 1.0,
	},
}