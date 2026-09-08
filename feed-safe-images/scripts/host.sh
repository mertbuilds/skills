#!/usr/bin/env bash
# Host files on a temporary public URL so Instagram's Graph API can fetch them.
# Uses a Cloudflare R2 bucket with a 1-day expiry lifecycle rule and a public dev URL.
# Auth: `wrangler login` (OAuth, stored by wrangler). No keys in this repo.
#
# Config file (chmod 600, outside the repo): $R2_STAGING_ENV, default ~/.config/cloudflare/r2-staging.env
#   R2_STAGING_BUCKET=<bucket name>
#   R2_STAGING_PUBLIC_URL=https://pub-<id>.r2.dev   (or a custom domain)
#
# Usage: host.sh <file>...   -> prints one public URL per file, in order
set -e
env_file=${R2_STAGING_ENV:-$HOME/.config/cloudflare/r2-staging.env}
[ -r "$env_file" ] || { echo "missing $env_file (see header)" >&2; exit 1; }
source "$env_file"
[ -n "$R2_STAGING_BUCKET" ] && [ -n "$R2_STAGING_PUBLIC_URL" ] || { echo "R2_STAGING_BUCKET / R2_STAGING_PUBLIC_URL unset in $env_file" >&2; exit 1; }
for f in "$@"; do
  key="$(date +%Y%m%d)/$(head -c 8 /dev/urandom | xxd -p)-$(basename "$f")"
  wrangler r2 object put "$R2_STAGING_BUCKET/$key" --file "$f" --remote >/dev/null 2>&1 \
    || wrangler r2 object put "$R2_STAGING_BUCKET/$key" --file "$f" --remote
  echo "$R2_STAGING_PUBLIC_URL/$key"
done
