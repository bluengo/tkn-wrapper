#!/usr/bin/env bash

# Colour formatting
# -----------------
readonly RED='\033[0;91m' > /dev/null 2>&1
readonly YELLOW='\033[0;93m' > /dev/null 2>&1
readonly GREEN='\033[0;92m' > /dev/null 2>&1
readonly RESET='\033[0m'> /dev/null 2>&1


# Logging
# --------
if [[ ! -z ${LOGFILE} ]]
    # if $LOGFILE is set, appends logs to it
    then LOG="${LOGFILE}"
    else LOG="/dev/null"
fi

timestamp() {
    date '+%Y-%m-%d %H:%M:%S -- '
}

log_ok() {
    # prints the timestamp with a green [OK] followed by the message ($1)
    echo -e "$(timestamp)${GREEN}[OK]:${RESET} ${1}" | tee -a ${LOG}
}

log_info() {
    # prints the timestamp with [INFO] followed by the message ($1)
    echo -e "$(timestamp)[INFO]: ${1}" | tee -a ${LOG}
}

log_warn() {
    # prints the timestamp with a yellow [WARNING] followed by the message ($1)
    echo -e "$(timestamp)${YELLOW}[WARNING]:${RESET} ${1}" | tee -a ${LOG}
}

log_err() {
    # prints the timestamp with a red [ERROR] followed by the message ($1)
    echo -e "$(timestamp)${RED}[ERROR]:${RESET} ${1}" | tee -a ${LOG}
}


# Exit on Error
# -------------
exit_on_err() {
    # prints the message ($2) as an error and exits with status ($1)
    log_err "${2}"
    echo -e "$(timestamp)${YELLOW}[EXIT]: Stopping execution now...${RESET}"
    exit ${1}
}


# Check dependencies
# ------------------
check_dependencies() {
    # receives a list of commands, and check that are present in the system.
    for package in ${1}
    do
        command -v ${package} > /dev/null
        if [[ $? != 0 ]]
            then log_err "The command ${package} is missing in the system"
            return 1
        fi
    done
    log_info "All dependencies are solved: ${1}"
    return 0
}