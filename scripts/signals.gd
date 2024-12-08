extends Node

## Signal sent once bus arrives at stop
signal bus_arrived
## Signal sent once bus leaves stop
signal bus_leaving

## Commuter added to worldview
signal commuter_added_to_scene(passenger: commuter)

## Commuter path setup in world view
signal commuter_path_setup(passenger: commuter, path_follow: PathFollow2D, lined_up: bool)
