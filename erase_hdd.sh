#!/bin/bash

# $KYAULabs: erase_hdd.sh,v 1.0.2 2026/08/06 12:53:00 kyau Exp $
# ▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
# █ ▄▄ ▄ ▄▄ ▄ ▄▄▄▄ ▄▄ ▄    ▄▄   ▄▄▄▄ ▄▄▄▄  ▄▄▄ ▀
# █ ██ █ ██ █ ██ █ ██ █    ██   ██ █ ██ █ ██▀  █
# ■ ██▄▀ ██▄█ ██▄█ ██ █ ▀▀ ██   ██▄█ ██▄▀ ▀██▄ ■
# █ ██ █ ▄▄ █ ██ █ ██ █    ██▄▄ ██ █ ██ █  ▄██ █
# ▄ ▀▀ ▀ ▀▀▀▀ ▀▀ ▀ ▀▀▀▀    ▀▀▀▀ ▀▀ ▀ ▀▀▀▀ ▀▀▀  █
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀
#
# Automated Arch Linux (KYAU Labs Edition)
# Copyright (C) 2026 KYAU Labs (https://kyaulabs.com)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -euo pipefail

readonly DISK="${1:-}"

if [[ -z "${DISK}" ]]; then
	echo "ERROR: No disk device specified."
	echo "Usage: $0 /dev/sdX"
	exit 1
fi

if [[ ! -b "${DISK}" ]]; then
	echo "ERROR: ${DISK} is not a block device."
	exit 1
fi

echo "Erasing disk: ${DISK}"
echo "This will destroy all data on ${DISK} and its partitions."

# Run each command without allowing one failure to hide later cleanup results.
run_cmd() {
	printf '▶'
	printf ' %q' "$@"
	printf '\n'
	if "$@"; then
		echo "  ✓ OK"
	else
		local rc=$?
		echo "  ✗ FAILED (exit code ${rc})"
		FAILED=$((FAILED + 1))
	fi
}

FAILED=0

run_cmd /usr/bin/pvremove -y -ff "${DISK}"*
run_cmd /usr/bin/dmsetup remove_all
run_cmd /usr/bin/wipefs -af "${DISK}"
run_cmd /usr/bin/dd if=/dev/zero of="${DISK}" bs=1k count=8192

if [[ ${FAILED} -eq 0 ]]; then
	echo "All commands completed successfully."
else
	echo "${FAILED} command(s) failed – check the output above."
fi

exit "${FAILED}"
