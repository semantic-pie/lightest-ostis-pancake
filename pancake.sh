#!/bin/bash

function usage() {
    cat <<USAGE

    Usage: 
        $0 install
     
    Options:
        install:       installs the necessary components ( sc-web, sc-machine ).

        pancake - entry point for management 'lightest-ostis-pancake'.

USAGE
    exit 1
}



case $1 in

# clone components
install)
    shift 1;

    if [ -e "sc-web" ]; then
        cd sc-web
        echo SC-WEB:
        git pull
        cd ..
    else
        git clone https://github.com/ostis-ai/sc-web
    fi

    if [ -e "sc-machine" ]; then
        cd sc-machine
        echo SC-MACHINE:
        git pull
        cd ..
    else
         git clone https://github.com/ostis-ai/sc-machine
    fi

    if [ -e "ims.ostis.kb" ]; then
        cd ims.ostis.kb
        echo KB.MINIMAL:
        git pull
        cd ..
    else
         git clone https://github.com/semantic-pie/minimal_kb ims.ostis.kb
    fi
    ;;

# show help
--help)
    usage
    ;;
help)
    usage
    ;;
-h)
    usage
    ;;

# All invalid commands will invoke usage page
*)
    usage
    ;;
esac
