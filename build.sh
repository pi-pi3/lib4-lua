#!/bin/sh

dir=$PWD
echo "Creating $2..."

rm -f $2

cd lib4/
zip -9 -r ../$2 main.lua conf.lua
cd $dir

for f in $(find lib4 -type f); do
    [ $f != 'lib4/main.lua' ] && zip -9 -r $2 $f
done

cd $1/
for f in $(find . -type f -regex '.*\.lua'); do
    zip -9 -r ../$2 $f
done

for f in src assets LICENSE README.md; do
    [[ -e ./$f ]] && zip -9 -r ../$2 $f
done
cd $dir

for lib in cpml iqm love3d; do
    zip -9 -r $2 lib/$lib
done

for lib in anim9 autobatch log tick json; do
    mv lib/$lib/$lib.lua lib/$lib/init.lua
    zip -9 -r $2 lib/$lib
    mv lib/$lib/init.lua lib/$lib/$lib.lua
done

echo "Done."
