#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd "${SCRIPT_DIR}/.." &>/dev/null

echo "EgoVenture publish script"
echo "========================="
echo

if [ ! -e "egoventure" ] || [ ! -e "parrot" ] || [ ! -e "speedy_gonzales" ] || [ ! -e "egoventure-game-template" ] || [ ! -e "egoventure-example-game" ]
then
    echo "This script requires the following directories:"
    echo "* egoventure-example-game/publish.sh"
    echo "* egoventure"
    echo "* speedy_gonzales"
    echo "* egoventure-game-template"
    echo
    echo "One or more directories were not found. Please check out the corresponding repositories."
    exit 1 
fi

git version &>/dev/null || ( echo "Did not find the git executable. Please install git." && exit 1 )
rsync --version &>/dev/null || ( echo "Did not find the rsync executable. Please install rsync." && exit 1 )

echo "Syncing source files"
echo "===================="

echo "Syncing parrot addon..."
if ! OUTPUT=$(rsync -av --del --exclude=plugin.cfg egoventure-example-game/addons/parrot/ parrot/addons/parrot/ 2>&1)
then
    echo "Error syncing parrot:"
    echo
    echo $OUTPUT
    exit 1
fi

echo "Syncing egoventure addon..."
if ! OUTPUT=$(rsync -av --del --exclude=plugin.cfg egoventure-example-game/addons/egoventure/ egoventure/addons/egoventure/ 2>&1)
then
    echo "Error syncing egoventure:"
    echo
    echo $OUTPUT
    exit 1
fi

echo "Syncing speedy_gonzales addon..."
if ! OUTPUT=$(rsync -av --del --exclude=plugin.cfg egoventure-example-game/addons/speedy_gonzales/ speedy_gonzales/addons/speedy_gonzales/ 2>&1)
then
    echo "Error syncing speedy_gonzales"
    echo
    echo $OUTPUT
    exit 1
fi

echo "Syncing egoventure game template..."
if ! OUTPUT=$(rsync -av --del egoventure-example-game/addons/ egoventure-game-template/addons/ 2>&1)
then
    echo "Error syncing egoventure game template"
    echo
    echo $OUTPUT
    exit 1
fi

echo
echo "Generating docs"
echo "==============="

echo "Generating Parrot API docs..."
rm -rf parrot/docs/api &>/dev/null
if ! OUTPUT=$(docker run --rm -v $(pwd)/egoventure-example-game:/game -v $(pwd)/parrot/docs/api:/export gdquest/gdscript-docs-maker:1 /game -o /export -d addons/parrot 2>&1)
then
    echo "Error generating Parrot API docs..."
    echo
    echo $OUTPUT
    exit 1
fi

echo "Generating Speedy API docs..."
rm -rf speedy_gonzales/docs/api &>/dev/null
if ! OUTPUT=$(docker run --rm -v $(pwd)/egoventure-example-game:/game -v $(pwd)/speedy_gonzales/docs/api:/export gdquest/gdscript-docs-maker:1 /game -o /export -d addons/speedy_gonzales)
then
    echo "Error generating Speedy API docs"
    echo
    echo $OUTPUT
    exit 1
fi

echo
echo "Displaying changes"
echo "=================="

echo "EgoVenture changes"

cd egoventure
git status
cd - &>/dev/null

echo "Parrot changes"

cd parrot
git status
cd - &>/dev/null

echo "Speedy changes"

cd speedy_gonzales
git status
cd - &>/dev/null

echo "Game template changes"

cd egoventure-game-template
git status
cd - &>/dev/null

