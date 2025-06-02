# StateMachine.gd
extends Node3D

@export var initial_state : State

var current_state : State
var states : Dictionary = {}
