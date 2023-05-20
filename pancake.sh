#!/bin/bash

WORKDIR=$(pwd)
KB_PATHS='repo.path'
touch $KB_PATHS # create if not exist
GIT_KB_REPOS_FILE='git.repo.path'
export GIT_TERMINAL_PROMPT=0 # чтобы гит не ****

function usage() {
    cat <<USAGE

    Usage: 
        $0 install
        $0 clean
        $0 add
     
    Options:
        install:       installs the necessary components ( sc-web, sc-machine ).
        clean:         remove all kb folders ( from repo.path ).
        add:           add kb git repository

        pancake - entry point for management 'lightest-ostis-pancake'.

USAGE
    exit 1
}


# ==============================================
# COMPONENTS PREPARE (SC-machine SC-web)

# clone / pull any component
function prepare_component() {
    REPO=$1
    NAME=$2
    echo -e "\033[1m[$NAME]\033[0m":
    if [ -e "$NAME" ]; then
        cd $NAME   
        git pull
    else
        git clone "$REPO" "$NAME"
    fi
    cd $WORKDIR
}

# clone / pull problem solver
# specific, cause its installation requires 
# injection to sc-machine CMakeList.txt
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
# UTILITIES 

# check if repo ever exist and clone
function clone_git_repo() {
    REPO=$1
    NAME=$2
    if git ls-remote --exit-code $REPO > /dev/null 2>&1; then
        # if repo exist - clone
        git clone --depth=1 "$REPO" "$NAME"
    else
        echo "Repo: [$REPO] not exist."
        exit 1
    fi
}

# add to repo.path if it's not there yet
function add_to_KB_PATHS() {
    if ! grep -Fxq "$1" "$KB_PATHS"; then
        echo "$1" >> $KB_PATHS
    fi
    if ! grep -Fxq "$1" ".gitignore"; then
        echo "$1" >> ".gitignore"
    fi
}

# remove from repo.path
function remove_from_KB_PATHS() {
    TEMP="path.temp"
    sed "/$1/d" "$KB_PATHS" >> $TEMP
    mv $TEMP "$KB_PATHS"
}


# ==============================================
# KNOWlEDGE BASES PREPARE

# clone / pull any kb
function prepare_kb() {
    REPO=$1
    NAME=$2
    echo -e "\033[1m[$NAME]\033[0m":

    if [ -e "$NAME" ]; then
        cd "$NAME"
        git pull
    else
        # clone repo and (if success) add repo name to repo.path
        clone_git_repo "$REPO" "$NAME" && add_to_KB_PATHS "$NAME"
    fi
    cd $WORKDIR
}

# clones all kb-repositories from git.repo.path
function prepare_all_kb() {
    # If the file exists
    if [ ! -f "$GIT_KB_REPOS_FILE" ]; then
        echo "git.repo.path not found!"
        exit 1
    fi

    # Loop through the file line by line
    while read -r repo_url repo_name || [[ -n "$repo_url" ]]; do
        # simple comments
        if [[ $repo_url == \#* ]]; then
            continue
        fi
        # if empty line
        if [ -z "$repo_url" ]; then
            continue 
        elif [ -z "$repo_name" ]; then
            repo_name=$(basename "$repo_url")
        fi

        prepare_kb "https://github.com/$repo_url" "$repo_name"

    done < "$GIT_KB_REPOS_FILE"  
}


# remove all local kb-repositories
function remove_all_kb() {
    # If the file exists
    if [ ! -f "$KB_PATHS" ]; then
        echo "repo.path not found!"
        exit 1
    fi

    # Loop through the file line by line
    while read -r repo_name; do
        # simple comments
        if [[  $repo_name == \#* ]]; then
            continue
        fi

        rm -rf "$repo_name"
        remove_from_KB_PATHS "$repo_name"

    done < "$KB_PATHS"  
}

# add to git.repo.path
function add_kb() {
    IFS=":" read -r repo_url repo_name <<< "$arg"
    
    if [[ ! $repo_url ]]; then
            exit
    fi
    
    if [[ ! $repo_name ]]; then
            repo_name=$(basename "$repo_url")
    fi

    if git ls-remote --exit-code https://github.com/$repo_url > /dev/null 2>&1; then
        # if repo exist - clone
        if ! grep -q -E "$repo_url|$repo_name" "$GIT_KB_REPOS_FILE"; then
            echo "$repo_url $repo_name" >> $GIT_KB_REPOS_FILE
        else 
            echo "Repository [$repo_url $repo_name] alredy exists"
        fi
    else
        echo "Repo: [https://github.com/$repo_url] not exist."
        exit 1
    fi
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
    prepare_all_kb
    
    shift 1;
    ;;
# clean project
clean)
    remove_all_kb
    shift 1;
    ;;
# add kb
add)
    shift 1;
    # remove_all_kb 
    for arg in "$@"
    do
        add_kb $arg
    done
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
