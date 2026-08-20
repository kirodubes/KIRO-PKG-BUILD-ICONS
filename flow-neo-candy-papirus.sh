#!/bin/bash
set -euo pipefail
#####################################################################
# Author    : Erik Dubois
# Website   : https://kiroproject.be
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
#   Purpose:
#   - Scoped flow for the neo-candy icon family touched by the
#     home/wastebasket work: the base (neo-candy-icons) plus every
#     neo-candy-papirus colour variant (the 25 generated colours +
#     casablanca).
#   - Step 1 pushes each EDU source repo to GitHub (the PKGBUILDs
#     build from those GitHub sources).
#   - Step 2 builds each matching recipe here (build.sh bumps pkgrel).
#   - Step 3 publishes nemesis_repo.
#
#   Why: ship ONLY this set in one command, instead of rebuilding
#   every icon package via 2-build-all-packages.sh.
#####################################################################

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

#####################################################################
# Config
#####################################################################
EDU_DIR="${HOME}/EDU"
NEMESIS_UP="${EDU_DIR}/nemesis_repo/up.sh"

# EDU source repo  ->  build-recipe dir (same basename, except the base)
BASE_EDU="neo-candy-icons"
BASE_PKG="neo-candy-icons-git"

#####################################################################
# Colors
#####################################################################
if command -v tput >/dev/null 2>&1 && [[ -t 1 ]]; then
    RED="$(tput setaf 1)"; GREEN="$(tput setaf 2)"; YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"; CYAN="$(tput setaf 6)"; RESET="$(tput sgr0)"
else
    RED="" GREEN="" YELLOW="" BLUE="" CYAN="" RESET=""
fi

#####################################################################
# Logging
#####################################################################
log_section() { echo; echo "${GREEN}############################################################################${RESET}"; echo "$1"; echo "${GREEN}############################################################################${RESET}"; echo; }
log_info()    { echo; echo "${BLUE}############################################################################${RESET}"; echo "$1"; echo "${BLUE}############################################################################${RESET}"; echo; }
log_warn()    { echo; echo "${YELLOW}############################################################################${RESET}"; echo "$1"; echo "${YELLOW}############################################################################${RESET}"; echo; }
log_error()   { echo; echo "${RED}############################################################################${RESET}"; echo "$1"; echo "${RED}############################################################################${RESET}"; echo; }
log_success() { echo; echo "${GREEN}############################################################################${RESET}"; echo "$1"; echo "${GREEN}############################################################################${RESET}"; echo; }

#####################################################################
# Error handling
#####################################################################
on_error() {
    local lineno="$1"
    local cmd="$2"
    echo
    echo "${RED}ERROR on line ${lineno}: ${cmd}${RESET}"
    echo
    sleep 10
}
trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

#####################################################################
# Functions
#####################################################################
collect_repos() {
    # echoes the EDU repo basenames in scope: base first, then every papirus colour
    echo "${BASE_EDU}"
    find "${EDU_DIR}" -maxdepth 1 -type d -name 'neo-candy-papirus-*' -printf '%f\n' | sort
}

push_sources() {
    local msg="$1" name dir branch
    log_section "Step 1/3 — pushing EDU source repos to GitHub"
    while IFS= read -r name; do
        dir="${EDU_DIR}/${name}"
        [[ -d "${dir}/.git" ]] || { log_warn "no git repo: ${name} — skipping push"; continue; }
        log_info "push: ${name}"
        cd "${dir}"
        git pull --ff-only || true
        git add --all .
        git commit -m "${msg}" || true
        branch="$(git symbolic-ref --short HEAD)"
        git push -u origin "${branch}"
    done < <(collect_repos)
}

build_packages() {
    local name pkgdir
    log_section "Step 2/3 — building package recipes"
    while IFS= read -r name; do
        if [[ "${name}" == "${BASE_EDU}" ]]; then pkgdir="${SCRIPT_DIR}/${BASE_PKG}"; else pkgdir="${SCRIPT_DIR}/${name}"; fi
        if [[ -d "${pkgdir}" ]] && compgen -G "${pkgdir}/build*" >/dev/null 2>&1; then
            log_info "build: $(basename "${pkgdir}")"
            ( cd "${pkgdir}" && sh ./build* )
        else
            log_warn "no build recipe for ${name} (${pkgdir}) — skipping"
        fi
    done < <(collect_repos)
}

publish_repo() {
    log_section "Step 3/3 — publishing nemesis_repo"
    [[ -f "${NEMESIS_UP}" ]] || { log_error "nemesis up.sh missing: ${NEMESIS_UP}"; exit 1; }
    bash "${NEMESIS_UP}"
}

main() {
    local msg="${1:-}"
    if [[ -z "${msg}" ]]; then
        echo "Type the commit message for the source repos:"
        read -r msg
    fi
    [[ -n "${msg}" ]] || { log_error "empty commit message"; exit 1; }

    log_section "neo-candy papirus flow — $(collect_repos | wc -l) repos in scope (base + papirus colours)"
    push_sources "${msg}"
    build_packages
    publish_repo
    log_success "$(basename "$0") done"
}

main "$@"
