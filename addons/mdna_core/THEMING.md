# Theming mdna core

## Introduction

MDNA games are very artistic and feature a lot of images and graphics. All aspects of the game look can be customized using Godot's [theming features](https://docs.godotengine.org/en/stable/tutorials/gui/gui_skinning.html).

A starter theme resource called _theme.tres_ is already available in the MDNA game template.

This document describes the available theming settings.

## Basic anatomy of the theme

Upon opening _theme.tres_ using the file system browser in Godot, the inspector shows the theme like this:

<img title="" src="file:///var/folders/8j/h44wpsp14kdff86yx8gkl0t40000gn/T/se.razola.Glui2/8023F831-6FC8-49F2-AE6C-EAA6B588DD66-626-00018BC10AD474A9/2021-01-15%20at%2021.43.png" alt="" data-align="center">

The theme is categorized in different UI element types. Throughout the game, different aspects use different UI elements to achieve the desired result.

Additionally, the game uses Godot's default dialog boxes for confirmation and messages. Because of this, not only special game features are included in the theme.

In this document, each category and setting is described.

## Default Font

The default font that is used throughout the game

## Button

| Subcategory | Setting              | Description                                          | Used in          |
| ----------- | -------------------- | ---------------------------------------------------- | ---------------- |
| Colors      | Font Color           | Color of the text on default buttons                 | Standard Dialogs |
|             | Font Color Hover     | Color of the text when hovering over default buttons | Standard Dialogs |
|             | Font Color Pressed   | Coloer of the text when pressing default buttons     | Standard Dialogs |
| Styles      | Focus                | Fill style of default buttons                        | Standard Dialogs |
|             | Hover                | Fill style used when hovering over default buttons   | Standard Dialogs |
|             | Menu Button Disabled | Fill style of menu buttons when disabled             | Main menu        |
|             | Menu Button Hover    | Fill style of menu buttons when hovered              | Main menu        |
|             | Menu Button Normal   | Fill style of menu buttons                           | Main menu        |
|             | Normal               | Fill style of default buttons                        | Standard Dialogs |
|             | Pressed              | Fill style of default buttons                        | Standard Dialogs |

## Check Button

Used in the game options for the "Subtitles"-setting

| Subcategory | Setting       | Description                                             | Used in      |
| ----------- | ------------- | ------------------------------------------------------- | ------------ |
| Icons       | Off           | The unchecked state image of the check button           | Game options |
|             | On            | The checked state image of the check button             | Game options |
| Styles      | Focus         | Fill style when the check button is focused             | Game options |
|             | Hover         | Fill style when the check button is hovered             | Game options |
|             | Hover Pressed | Fill style when the check button is hovered and checked | Game options |
|             | Normal        | Fill style for the check button                         | Game options |
|             | Pressed       | Fill style for the check button is pressed              | Game options |

## H Slider

Used in the game options for the "Volume"-settings

| Subcategory | Setting                | Description                                                   | Used in      |
| ----------- | ---------------------- | ------------------------------------------------------------- | ------------ |
| Icons       | Grabber                | The image used for the grabber in the slider                  | Game options |
|             | Grabber Highlight      | The image used for the grabber when the slider is highlighted | Game options |
|             | Tick                   | The image used for the ticks in the slider                    | Game options |
| Styles      | Grabber Area           | The fill for the grabber area                                 | Game options |
|             | Grabber Area Highlight | The fill for the grabber area when highlighted                | Game options |
|             | Slider                 | The fill for the slider                                       | Game options |

## Label

| Subcategory | Setting | Description                                | Used in |
| ----------- | ------- | ------------------------------------------ | ------- |
| Colors      | Goals   | The font color of the goals in the notepad | Notepad |
|             | Hints   | The font color of the hints in the notepad | Notepad |
| Fonts       | Goals   | The font used for the goals in the notepad | Notepad |
|             | Hints   | The font used for the hints in the notepad | Notepad |

## Panel

| Subcategory | Setting         | Description                                           | Used in     |
| ----------- | --------------- | ----------------------------------------------------- | ----------- |
| Styles      | Detail View     | The background used in the inventory item detail view | Detail view |
|             | Dialog Panel    | The background used in the Parrot dialogs             | Dialogs     |
|             | Inventory Panel | The background of the inventory panel                 | Inventory   |
|             | Notepad Panel   | The background behind the image of the notepad        | Notepad     |
|             | Saveslot Panel  | The design of an empty saveslot                       | Save Slots  |

## Progress Bar

| Subcategory | Setting | Description                             | Used in        |
| ----------- | ------- | --------------------------------------- | -------------- |
| Styles      | Bg      | The background of the progress bar      | Loading screen |
|             | Fg      | The foreground fill of the progress bar | Loading screen |

## Rich Text Label

| Subcategory | Setting     | Description                     | Used in |
| ----------- | ----------- | ------------------------------- | ------- |
| Fonts       | Dialog Font | Font used in the parrot dialogs | Dialogs |
