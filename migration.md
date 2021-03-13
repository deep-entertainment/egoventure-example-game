# Migration guide

The following things have changed while moving from the old code to the EgoVenture code.

## MdnaCore => EgoVenture

* The singleton `MdnaCore` is now called `EgoVenture`. Please replace all occurences of `MdnaCore`  with `EgoVenture` in code.

## MdnaInventory => Inventory

* The singleton `MdnaInventory` is now called `Inventory`. Please replace all occurences of `MdnaInventory` with `Inventory`.

## Notepad

* The function `Notepad.finished_step` is called `Notepad.progress_goal` now

# Hotspot-Type => Cursor-types and Cursors

* The property "Hotspot type" was changed to "Cursor type" for clarity
* I had to remove Type.CUSTOM4 and the cursor shape for CUSTOM3 changed from Input.CURSOR_ARROW to Input.CURSOR_WAIT
