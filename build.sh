#!/bin/sh

dir=$PWD
love=$2
if [ $1 == '--bare' ]; then
    love=lib4.love

    cd $2
    echo "Creating $love..."
    
    rm -f $dir/$love
    
    cd lib4/
    zip -9 -r $dir/$love main.lua conf.lua
    cd ..
    
    for f in $(find lib4 -type f); do
        [ $f != 'lib4/main.lua' ] && zip -9 -r $dir/$love $f
    done
    
    for lib in cpml iqm love3d; do
        for f in $(find lib/$lib -type f); do
            [[ $f != *.git* ]] && zip -9 -r $dir/$love $f
        done
    done
    
    for lib in anim9 autobatch log tick json; do
        mv lib/$lib/$lib.lua lib/$lib/init.lua
        for f in $(find lib/$lib -type f); do
            [[ $f != *.git* ]] && zip -9 -r $dir/$love $f
        done
        mv lib/$lib/init.lua lib/$lib/$lib.lua
    done

    cd $dir
    
    echo "Done."
else
    echo "Creating $love..."
    
    rm -f $dir/$love
    
    cd lib4/
    zip -9 -r $dir/$love main.lua conf.lua
    cd $dir
    
    for f in $(find lib4 -type f); do
        [ $f != 'lib4/main.lua' ] && zip -9 -r $dir/$love $f
    done
    
    cd $1/
    for f in $(find . -type f -regex '.*\.lua'); do
        [[ $f != *.git* ]] && zip -9 -r $dir/$love $f
    done
    
    for f in src assets LICENSE README.md; do
        [[ -e ./$f ]] && zip -9 -r $dir/$love $f
    done
    cd $dir
    
    for lib in cpml iqm love3d; do
        for f in $(find lib/$lib -type f); do
            [[ $f != *.git* ]] && zip -9 -r $dir/$love $f
        done
    done
    
    for lib in anim9 autobatch log tick json; do
        mv lib/$lib/$lib.lua lib/$lib/init.lua
        for f in $(find lib/$lib -type f); do
            [[ $f != *.git* ]] && zip -9 -r $dir/$love $f
        done
        mv lib/$lib/init.lua lib/$lib/$lib.lua
    done
    
    echo "Done."
fi
