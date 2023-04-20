#!/bin/bash

WORKDIR=$(pwd)
KB_PATHS='repo.path'

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

# ==============================================
# COMPONENTS PREPARE

# clone / pull any component
# $1 github repo
# $2 folder name
function prepare_component() {
    REPO=$1
    NAME=$2
    echo -e "\033[1m[$NAME]\033[0m":
    if [ -e "$NAME" ]; then
        cd $NAME
        git pull
        echo e
    else
        git clone "$REPO" "$NAME"
        echo not
    fi
    cd $WORKDIR    
}

# clone / pull problem solver
# specific, since its installation requires 
# injection to sc-machine CmakeList
function prepare_problem_solver() {
    echo -e "\033[1m[problem-solver]\033[0m":
    if [ -e "sc-machine/problem-solver" ]; then
        cd sc-machine/problem-solver
        git pull
    else 
        cd sc-machine
        git clone https://github.com/semantic-pie/problem-solver
        echo 'add_subdirectory(${SC_MACHINE_ROOT}/problem-solver)' >> CMakeLists.txt
    fi
    cd $WORKDIR
}

# ==============================================
# KNOWlEDGE BASES PREPARE

# clone / pull any kb and add them to repo.path
# $1 github repo
# $2 folder name
function prepare_kb() {
    REPO=$1
    NAME=$2
    echo -e "\033[1m[$NAME]\033[0m":

    if [ -e "$NAME" ]; then
        cd "$NAME"
        git pull
    else
         git clone "$REPO" "$NAME"
         echo "$NAME" >> $KB_PATHS
    fi
    cd $WORKDIR
}

# ==============================================
# COMMAND SWITCHER

case $1 in

# clone components
install)
    # clone vitally important components 
    prepare_component https://github.com/ostis-ai/sc-machine sc-machine
    prepare_component https://github.com/ostis-ai/sc-web sc-web
    prepare_problem_solver

    # clone knowledge bases
    prepare_kb https://github.com/semantic-pie/minimal_kb ims.ostis.kb
    prepare_kb https://github.com/semantic-pie/music.ostis.kb music.ostis.kb
    prepare_kb https://github.com/qaip/gt graph.ostis.kb
    
    shift 1;
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
