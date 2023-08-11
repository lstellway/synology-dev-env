#!/bin/bash
# INFO.sh

source /pkgscripts/include/pkg_util.sh

package="VIM"
version="9.0.1276"
os_min_ver="7.2-64561"
displayname="VIM 9.0.1276"
description="VIM text editor"
arch="$(pkg_get_platform)"
maintainer="Logan Stellway"
pkg_dump_info

