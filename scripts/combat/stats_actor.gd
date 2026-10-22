extends "res://scripts/hybrid/proxy_actor.gd"
const ActorState = preload("res://scripts/combat/actor_state.gd")
const ActorProfile = preload("res://scripts/combat/actor_profile.gd")
var state := ActorState.new()

func configure(profile: ActorProfile) -> void:
	state = ActorState.new(profile)
