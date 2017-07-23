#!/bin/sh

dir=$PWD
love=$2
if [ $1 == '--bare' ]; then
    love=lib4.love

    cd $2/
    echo "Creating $love..."
    
    rm -f $dir/$love
    
    cd lib4/
    zip -9 -r $dir/$love main.lua conf.lua
    cd ../
    
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

    cd $dir/
    
    echo "Done."
elif [ -f 'lib4.love' ]; then
    echo "Creating $love..."

    rm -f $dir/$love

    tmp=$(mktemp -d)
    unzip -d $tmp lib4.love
    
    rm -f $dir/$love

    cd $tmp
    zip -9 -r $dir/$love *
    cd $dir
    
    for f in src assets LICENSE README.md; do
        [[ -e ./$f ]] && zip -9 -r $dir/$love $f
    done
    cd $dir/
    
    echo "Done."
else
    echo "Creating $love..."
    
    rm -f $dir/$love

    if [[ -e $dir/lib4/lib4 ]]; then
        cd lib4
    fi
    
    cd lib4/
    zip -9 -r $dir/$love main.lua conf.lua
    cd $dir/
    
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

    if [[ -e $dir/lib4/lib4 ]]; then
        cd $dir
    fi
    
    cd $1
    for f in src assets LICENSE README.md; do
        [[ -e ./$f ]] && zip -9 -r $dir/$love $f
    done
    cd $dir/
    
    echo "Done."
fi
