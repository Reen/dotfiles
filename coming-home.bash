#!/bin/bash
# get dotfiles
dotfiles=$(ls -la | grep -v ^d | awk '{print $8}'| grep -v ^coming-home.bash$ )
mode=${1:-normal}
 
for x in $dotfiles; do
    # fishing errors
    if [ ! -e $x ] ; then echo "error reading files" ; exit 1 ; fi
    # keep old .bashrc
    if [ $x = ".bashrc" ]; then
        if [ ! -e $HOME/.bashrc_old ]; then
            cp $HOME/.bashrc $HOME/.bashrc_old
        fi
    fi
    # forced hook
    if [ $mode = "--hook" ]; then echo "hook: copying $x" ; /bin/cp -r $x $HOME/ ; fi
    # standard run
    if [ $mode != "--hook" ]; then /bin/cp -i $x $HOME/ ; fi
done
