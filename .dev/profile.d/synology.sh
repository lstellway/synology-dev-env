TOOLKIT_DIR="/data/toolkit"
PKGSCRIPTS_DIR="${TOOLKIT_DIR}/pkgscripts-ng"
PKGSCRIPTS_GIT="https://github.com/SynologyOpenSource/pkgscripts-ng.git"
SYNO_CPU_URL="https://kb.synology.com/en-global/DSM/tutorial/What_kind_of_CPU_does_my_NAS_have"

# Usage
#   _syno_exit EXIT_CODE EXIT_MESSAGE
#
#   Example:
#     _syno_exit 1 "An error occurred"
#     _syno_exit 0 "Things happened as expected!"
_syno_exit() {
    echo "${1}"
}

_syno_install() {
    [ -d "${PKGSCRIPTS_DIR}" ] && return

    mkdir -p "${TOOLKIT_DIR}" \
        && git clone "${PKGSCRIPTS_GIT}" "${PKGSCRIPTS_DIR}"
}

_syno_env_deploy() {
    ${PKGSCRIPTS_DIR}/EnvDeploy $@
}

_syno_valid_deploy_args() {
    cd "${PKGSCRIPTS_DIR}"

    # Ensure DSM version was provided
    DSM_VERSION="${1}"
    [ -n "${DSM_VERSION}" ] || _syno_exit 1 "No version provided as the first argument"

    # Ensure DSM version correlates to a valid branch name
    BRANCH="DSM${DSM_VERSION}"
    (git fetch origin "${BRANCH}" && git checkout "${BRANCH}") \
        || _syno_exit 1 "Version branch '${BRANCH}' does not exist"

    # Ensure architecture is provided as the second argument
    ARCHITECTURE=$(printf "${2}" | tr '[:upper:]' '[:lower:]')
    [ -n "${ARCHITECTURE}" ] || \
        ( \
            _syno_env_deploy -v "${DSM_VERSION}" --list \
                && _syno_exit 1 "Architecture not provided as second argument\nFind it here: ${SYNO_CPU_URL}"\
        )
}

_syno_remove() {
    DSM_VERSION="${1}"
    ARCHITECTURE=$(printf "${2}" | tr '[:upper:]' '[:lower:]')
    DIR="${TOOLKIT_DIR}/build_env/ds.${ARCHITECTURE}-${DSM_VERSION}"

    # Ensure directory exists
    [ -d "${DIR}" ] || _syno_exit 0 "Directory '${DIR}' does not exist"

    # Remove environment
    chroot "${DIR}" umount /proc
    rm -rf "${DIR}"
}

# Deploy environment
# @see https://help.synology.com/developer-guide/getting_started/prepare_environment.html#deploy-chroot-environment-for-different-nas-target
#
# This will download a tarball for the specified DSM version and architecture.
# Optionally, you can manually download tarballs
# @see https://archive.synology.com/download/
_syno_deploy() {
    _syno_valid_deploy_args $@ || exit 1
    DSM_VERSION="${1}"
    BRANCH="DSM${DSM_VERSION}"
    ARCHITECTURE=$(printf "${2}" | tr '[:upper:]' '[:lower:]')

    # Deploy toolkit version
    _syno_env_deploy -v "${DSM_VERSION}" -p "${ARCHITECTURE}"
}

# Build package
# @see https://help.synology.com/developer-guide/getting_started/first_package.html
_syno_compile() {
    _syno_valid_deploy_args $@ || exit 1
    DSM_VERSION="${1}"
    BRANCH="DSM${DSM_VERSION}"
    ARCHITECTURE=$(printf "${2}" | tr '[:upper:]' '[:lower:]')

    PACKAGE="${3}"
    PACKAGE_DIR="${TOOLKIT_DIR}/source/${PACKAGE}"
    [ -d "${PACKAGE_DIR}" ] || _syno_exit 1 "Package directory '${PACKAGE_DIR}' does not exist"

    # Deploy toolkit version
    ${PKGSCRIPTS_DIR}/PkgCreate.py -v "${DSM_VERSION}" -p "${ARCHITECTURE}" -c "${PACKAGE}"
}

