#!/bin/bash

WORKDIR=$(pwd)

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

function prepare_sc_machine() {
    echo -e "\033[1mSC-MACHINE\033[0m":
    if [ -e "sc-machine" ]; then
        cd sc-machine
        git pull
    else
         git clone https://github.com/ostis-ai/sc-machine
    fi
    cd $WORKDIR
}

function prepare_problem_solver() {
    echo -e "\033[1mPROBLEM-SOLVER\033[0m":
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

function prepare_sc_web() {
    echo -e "\033[1mSC-WEB\033[0m":
    if [ -e "sc-web" ]; then
        cd sc-web
        git pull
    else
        git clone https://github.com/ostis-ai/sc-web
    fi
    cd $WORKDIR
}

function prepare_kb_ims() {
    echo -e "\033[1mIMS.KB\033[0m":
    if [ -e "ims.ostis.kb" ]; then
        cd ims.ostis.kb
        git pull
    else
         git clone https://github.com/semantic-pie/minimal_kb ims.ostis.kb
        #  echo 'ims.ostis.kb' >> repo.path
    fi
    cd $WORKDIR
}

function prepare_kb_music() {
    echo -e "\033[1mMUSIC.KB\033[0m":
    if [ -e "music.ostis.kb" ]; then
        cd music.ostis.kb
        git pull
    else
         git clone https://github.com/semantic-pie/music.ostis.kb
        #  echo 'music.ostis.kb' >> repo.path
    fi
    cd $WORKDIR
}

function prepare_kb_grap() {
    echo -e "\033[1mGRAPH.KB\033[0m":
    if [ -e "graph.ostis.kb" ]; then
        cd graph.ostis.kb
        git pull
    else
        git clone https://github.com/qaip/gt graph.ostis.kb
        #  echo 'music.ostis.kb' >> repo.path
    fi
    cd $WORKDIR
}

case $1 in

# clone components
install)
    shift 1;
    prepare_sc_web
    prepare_sc_machine
    prepare_problem_solver
    prepare_kb_ims
    prepare_kb_music
    prepare_kb_grap
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
