#!/usr/bin/env bash
# Fail when a vendored copy of the plugin interface differs from the source of
# truth in wit/plugin.wit, or when wit/VERSION disagrees with the WIT package
# version. Prints the sha256 of each file. Pure shell plus sha256sum.
#
#   scripts/check-wit-copies.sh
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_wit="wit/plugin.wit"
copies=("examples/word-count/wit/plugin.wit")

status=0
cd "$root"

hash_of() { sha256sum "$1" | cut -d' ' -f1; }

want="$(hash_of "$source_wit")"
echo "$want  $source_wit (source of truth)"

for copy in "${copies[@]}"; do
  if [[ ! -f "$copy" ]]; then
    echo "MISSING  $copy" >&2
    status=1
    continue
  fi
  got="$(hash_of "$copy")"
  echo "$got  $copy"
  if [[ "$got" != "$want" ]]; then
    echo "DIFFERS  $copy does not match $source_wit" >&2
    status=1
  fi
done

declared="$(sed -n 's/^package manang:plugin@\(.*\);.*/\1/p' "$source_wit" | head -n 1)"
version="$(tr -d '[:space:]' < wit/VERSION)"
if [[ "$declared" != "$version" ]]; then
  echo "DIFFERS  wit/VERSION is '$version' but $source_wit declares '$declared'" >&2
  status=1
fi

if [[ $status -eq 0 ]]; then
  echo "ok: all copies match, interface version $version"
fi
exit $status
