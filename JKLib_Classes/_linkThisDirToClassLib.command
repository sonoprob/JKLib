#!/bin/bash

# makes a symbolic link from here to supercollider's extensions directory
# in order for sc class files ( all files ending with .sc) to become available

OS=`uname -s`
EXTRACLASSESPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

case $OS in
	"Darwin" )
	EXTENSIONSPATH=$HOME"/Library/Application Support/SuperCollider/Extensions"
	;;
	"Linux" )
	echo "not yet implemented..."
	exit 1
	;;
esac

echo

ln -s $EXTRACLASSESPATH "$EXTENSIONSPATH"
echo "$EXTRACLASSESPATH symlinked from sc extensions folder"
echo "please recompile supercollider's class library"
echo

exit 0
