#!/bin/sh

echo "Creating $2..."

rm -f $2
echo "rm -f $2"

cd $1/
zip -9 -r ../$2 *
echo "cd $1/; zip -9 -r ../$2 *"

cd ../lib4/
zip -9 -r ../$2 *
echo "cd ../lib4/; zip -9 -r ../$2 *"
cd ..

for lib in cpml iqm love3d; do
    zip -9 -r $2 lib/$lib
done

for lib in anim9 autobatch log tick; do
    mv lib/$lib/$lib.lua lib/$lib/init.lua
    echo "mv lib/$lib/$lib.lua lib/$lib/init.lua"

    zip -9 -r $2 lib/$lib
    echo "zip -9 -r $2 lib/$lib/*"

    mv lib/$lib/init.lua lib/$lib/$lib.lua
    echo "mv lib/$lib/init.lua lib/$lib/$lib.lua"
done

echo "Done."
