# A simple sprite flashing a map
extends CanvasLayer


# configure the map notification
func configure(configuration: GameConfiguration):
	$Map.texture = configuration.map_image
	$Sound.stream = configuration.map_sound
	

# Run the notification
func notify():
	$Animation.play("notification")
	$Sound.play()
	
