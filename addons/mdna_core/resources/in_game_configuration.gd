# A configuration for game-wide elements (like sound settings)
class_name InGameConfiguration
extends Resource


# Wether subtitles should be shown
var subtitles = true

# The volume of the speech channel in db
var speech_db = 0

# The volume of the music channel in db
var music_db = 0

# The volume of the effects channel in db
var effects_db = 0

# The resume state, that is saved automatically
var resume_state = null
