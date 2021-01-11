# mdna_inventory - An inventory framework for MDNA games

## Introduction

This inventory framework is used by [MDNA games](https//mdna-games.com) for their
first person point and click adventure games.

As it might be usable to other developers as well, we decided to release this
under an open source license.

It currently supports the following features:

* An automatically hidden inventory bar or a manuall trigger (on touchscreen devices)
* Adding inventory items with names, descriptions and textures
* Mouse cursor support
* Trigger hotspots that react on specific selected inventory items
* Touch support
* Easy configuration
* Theming

## Usage

To use the inventory system, install the addon and create a new configuration resource
based on InventoryConfiguration.

Create a singleton/Autoload script and call the following function from the _ready
function:

    MdnaInventory.configure(preload("res://path/to/inventoryconfiguration.tres"))

(If you're also using the mdna_core addon, you don't need to add this code as the
core autoload already calls it. You have to configure the inventory configuration
in the game configuration though)

## Inventory items

Inventory items are based on the InventoryItem resource. For each inventory item
in your game, create a new InventoryItem resource.

The resource contains:

* Name: The name of the inventory item
* Description: A description of the inventory item
* Image normal: The standard image for the item used in the inventory
* Imate active: The image for the item used when highlighting the item
* Image big: The big image shown to the player together with the description

To add a new inventory item, run

    MdnaInventory.add_item(preload("res://path/to/item.tres"))

The currently selected item can be retrieved by using:

    MdnaInventory.selected_item.item

## Trigger hotspots

You can use special hotspots inside a scene that will react to certain
inventory items and enut a signal when one of the valid items are selected
and the hotspot is triggered. The item used will be supplied as a parameter
to the signal.

## Combining items

MdnaInventory will emit a signal when two inventory items were combined.

The two items will be added as parameters to the signal.

The signal can be used in your game's singleton and be reacted upon:

    MdnaInventory.connect("triggered_inventory_item", self, "_on_triggered_inventory_item")

## Development

If you find bugs or need more features, please open an issue within this repository. As this framework is used internally by MdnaGames,
we'll have to consider each new feature.

If a new feature doesn't match or contradicts our needs, we might refuse to accept it, but welcome you to fork this repository and implement
it yourself.

You're welcomed to open pull requests about bugs or (confirmed) features any time and we'll review it and might ask you for
modifications.
