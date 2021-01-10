# mdna_core - The core framework for MDNA Games production
## Introduction
This is a [Godot](https://godotengine.org) framework used by [MDNA games](https://mdna-games.com/) for their
first person point and click adventure games.
It's streamlined for these games, but may be of use for other developers as well. Thus we're releasing it as Open Source under
the MIT license.
## Features
The framework takes care of the basic and common features of the games, namely:
* The main menu handling:
  * Starting a new game
  * Loading and saving games
  * Game options
  * Quitting
  * Restarting
* Game state handling
* Audio playback
* Scene caching
* Scene helpers
  * Hotspots with different features (general hotspot, look hotspot)
  * 4-view room template scene
  * Map Hotspots (with caching features)
* Mouse cursor handling
* Game configuration
* Theming
Check out the API docs for details.
## Usage
Load and activate the plugin using Godots Assetlib or use the template game for starters.
Create a game configuration resource based on the GameConfiguration custom resource and configure various
aspects of the game.
Create a new class extending BaseState (e.g. called "GameState"):
```
class_name GameState
extends BaseState
```
This class can be used throughout the game by accessing `(MdnaCore.state as GameState)` and can hold various (exported!) variables
to keep track about changes in the game.
Example:
```
export (bool) var has_keys = false  # Carol picked up the keys
```
*The state is automatically persisted in save games!*
Create a singleton to handle game handling and use the following code in the `_ready` function to initiate the framework:
```
	MdnaCore.state = GameState.new()
	MdnaCore.configure(preload("res://configuration.tres"))
	MainMenu.connect("new_game", self, "_on_new_game")
```
Now, the function `_on_new_game` will be called when the player clicks "New Game" in the main menu.
## Development
If you find bugs or need more features, please open an issue within this repository. As this framework is used internally by MdnaGames,
we'll have to consider each new feature.
If a new feature doesn't match or contradicts our needs, we might refuse to accept it, but welcome you to fork this repository and implement
it yourself.
You're welcomed to open pull requests about bugs or (confirmed) features any time and we'll review it and might ask you for
modifications.
