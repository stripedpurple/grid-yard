#!/bin/bash 

# Variables

readonly thisScript=$(basename $0 | sed 's/\.sh//g')
readonly default="\033[39m"
readonly black="\033[30m"
readonly red="\033[31m"
readonly green="\033[32m"
readonly yellow="\033[33m"
readonly blue="\033[34m"
readonly argsLength=$#

CSS=./css/gridyard.css
MIN_CSS=./css/gridyard.min.css
MAIN_SASS=./sass/main.sass
SASS_BIN=$(which sass)
export SASS_ENV=$1


# Fuction
function log () {
    case "$1" in
        err)
            echo -e    "$red[$( date )] [$(basename $0)] [ERROR  ]$default $2" | tee -a /tmp/biobrain-init.log
            ;;
        info)
              echo -e "$blue[$( date )] [$(basename $0)] [INFO   ]$default $2" | tee -a /tmp/biobrain-init.log
            ;;
        scss)
             echo -e "$green[$( date )] [$(basename $0)] [SUCCESS]$default $2" | tee -a /tmp/biobrain-init.log
            ;;
        warn)
            echo -e "$yellow[$( date )] [$(basename $0)] [WARNING]$default $2" | tee -a /tmp/biobrain-init.log
            ;;
    esac
}



if  [[ -z "$SASS_ENV" ]] || [[ "$SASS_ENV" == "build" ]]; then
    log info "Building MIN CSS"
    log info "OUTPUT: $MIN_CSS"
    { 
        $SASS_BIN $MAIN_SASS $MIN_CSS -t compressed && log scss "Successfully built MIN CSS" 
    } || log err "Could not build $MIN_CSS"

    log info "Building CSS"
    log info "OUTPUT: $CSS"
    { 
        $SASS_BIN $MAIN_SASS $CSS -t expanded && log scss "Successfully built CSS" 
    } || log err "Could not build $CSS"

elif [[ "$SASS_ENV" == "development" ]] || [[ "$SASS_ENV" == "develop" ]] || [[ "$SASS_ENV" == "dev" ]]; then
    $SASS_BIN --watch $MAIN_SASS:$CSS -t expanded 
else
    log err "Please pass a valid option."
fi

