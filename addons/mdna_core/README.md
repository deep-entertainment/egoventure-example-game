# mdna_core - The core framework for MDNA Games production

## Introduction

This is a [Godot](https://godotengine.org) framework used by [MDNA games](https://mdna-games.com/) for their first person point and click adventure games.

It's streamlined for these games, but may be of use for other developers as well. Thus we're releasing it as Open Source under the MIT license.

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

The plugin is loaded and imported using Godots Assetlib and activated in the project setting's addons. It is already activated in the MDNA Game template.

Various aspects of the game are configured using a special custom resource called _GameConfiguration_. (see [below](#configuration))

For a new game, create a game configuration resource based on _GameConfiguration_.

Changes in the game are recorded using a _state_. Every game needs its own state. The state is automatically persisted in save games.

Create a new class extending BaseState (e.g. called "GameState"):

```
class_name GameState
extends BaseState
```

This class is accessed using `(MdnaCore.state as GameState)` to query or record game changes.

Example:

```
export (bool) var has_keys = false  # Carol picked up the keys
```

The game needs to connect the new resource and class to mdna_core and also handle certain signals.

Create a singleton to handle game handling and use the following code in the `_ready` function to initiate the framework:

```
MdnaCore.state = GameState.new()
MdnaCore.configure(preload("res://configuration.tres"))
```

## Signals

Certain events in the game emit signals, that need to be handled in the game's singleton.

| Object   | Signal         | Description                                                 |
| -------- | -------------- | ----------------------------------------------------------- |
| MainMenu | new_game       | Emitted when the user clicks on "New game" in the main menu |
| MdnaCore | game_loaded    | Emitted when a game was loaded from a save game             |
| MdnaCore | queue_complete | Emitted when the scene cache has completed updating         |

## Configuration

The _GameConfiguration_ resource type contains many properties that control various aspects of the game. The following configurations are available:

### Common

| Property                    | Description                                                                          | Used in        |
| --------------------------- | ------------------------------------------------------------------------------------ | -------------- |
| Theme                       | The [theme](addons/mdna_core/THEMING.md_) used to style the certain graphic elements | Various parts  |
| Logo                        | The game logo used at the top of the main menu                                       | Main menu      |
| Hotspot Cursors             | A list of [hotspot cursor](#mouse_cursors) configurations                            | Mouse cursors  |
| Inventory configuration     | The configuration for the mdna_inventory addon                                       | Core           |
| Hints File                  | The hints csv file                                                                   | Notepad        |
| Map Image                   | The image used for the map notification                                              | Scenes         |
| Map Sound                   | Sound played when the map notification is shown                                      | Scenes         |
| Scene Path                  | The path where the game scenes are located                                           | Scene cache    |
| Scene Cache Count           | Number of scenes before and after the current one that are precached                 | Scene cache    |
| Scene default image scaling | Used when images are not exactly sized like the game resolution                      | Room templates |

### Menu

| Property      | Description                                       | Used in   |
| ------------- | ------------------------------------------------- | --------- |
| Background    | The menu background                               | Main menu |
| Music         | The music playing in the main menu                | Main menu |
| Switch Effect | The sound effect playing when buttons are clicked | Main menu |

### Save slots

| Property       | Description                                             | Used in    |
| -------------- | ------------------------------------------------------- | ---------- |
| Background     | Background                                              | Save slots |
| Previous Image | Image used to navigate to the previous save slot screen | Save slots |
| Next images    | Image used to navigate to the next save slot screen     | Save slots |

### Notepad

| Property   | Description                        | Used in |
| ---------- | ---------------------------------- | ------- |
| Background | Background image of the notepad    | Notepad |
| Goals Rect | Rectangular area of the goals list | Notepad |
| Hints Rect | Rectangular area of the hints list | Notepad |

### Options

| Property       | Description                                    | Used in |
| -------------- | ---------------------------------------------- | ------- |
| Background     | Background of the options screen               | Options |
| Speech Sample  | Sample to play when changing the speech volume | Options |
| Effects sample | Sample to play when changin the effects volume | Options |

## Development

If you find bugs or need more features, please open an issue within this repository. As this framework is used internally by MdnaGames, we'll have to consider each new feature.

If a new feature doesn't match or contradicts our needs, we might refuse to accept it, but welcome you to fork this repository and implement it yourself.

You're welcomed to open pull requests about bugs or (confirmed) features any time and we'll review it and might ask you for modifications.
