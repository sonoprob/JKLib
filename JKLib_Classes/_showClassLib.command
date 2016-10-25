#!/bin/bash


# dit script opent de supercollider Extensions dir
EXTENSIONSPATH=$HOME"/Library/Application Support/SuperCollider/Extensions"

cd "$EXTENSIONSPATH"

ls -la .

open "$EXTENSIONSPATH"

exit 0
