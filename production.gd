class_name Production
extends Resource

@export var wheat: int
@export var wood: int


# TODO: maybe find a more logical way to arrange the collection of resources in the production class
# TODO: change to return a new production without modifying the values in the current one
# Combines the production values from this production with the passed one
func combine(production: Production) -> void:
	wheat += production.wheat
	wood += production.wood
