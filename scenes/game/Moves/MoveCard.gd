extends Resource
class_name Move

##Array of Notes the Move will have, fill this with the arrow key meant to be pressed (add key in all lowercase)
@export var Notes: Array[StringName] = []
@export var Cost: Array[StringName] = []
@export var AnimName: StringName
##Array of the amount of time (in seconds) between spawn of each note.
##First value here maps to the time between first and second values of Notes
@export var Timings: Array[float] = []

@export var Multiplier: float = 1.0

#See "res://Moves/Example.tres" for the formatting to be followed
