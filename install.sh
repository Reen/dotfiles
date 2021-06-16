#!/bin/bash 

# Very simple install script

for file in `find ${PWD} -maxdepth 1 -not -name '.*' -not -name install.sh -not -name bin -not -name tasks -not -name etc`; do
    if [ "${file}" == "${PWD}" ]
    then
        continue
    fi
    filename=`basename "$file"`
    if [ -h ~/.$filename ]
    then
        continue
    fi
    echo "ln -s `pwd`/$filename -> ~/.$filename"
    ln -s `pwd`/$filename ~/.$filename
done

