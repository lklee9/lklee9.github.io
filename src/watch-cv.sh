#!/bin/sh
# Rebuild the site whenever a .scm source file changes.
#
# Each change spawns a FRESH `haunt build`.  Do not use `haunt serve --watch`
# for this: that process keeps the already-loaded (lklee cv content) module in
# memory, so it rebuilds on save but writes the OLD content.
#
# LC_ALL is required.  Without a UTF-8 locale Guile falls back to a non-UTF-8
# port encoding and silently replaces every non-ASCII character (the en dashes
# in date ranges, the alpha-beta in the thesis description) with "?".

cd "$(dirname "$0")" || exit 1
export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export GUILE_LOAD_PATH="$PWD:$GUILE_LOAD_PATH"

# Watch the Scheme sources AND the assets the build consumes.  pubs.bib and
# pubs.json feed the publication list and styles.css is copied into the site,
# so a .scm-only fingerprint silently misses edits to any of them.
fingerprint() {
    find . \( -name '*.scm' -o -name '*.bib' -o -name '*.json' \
              -o -name '*.css' \) -exec stat -f '%m %N' {} \; | sort | md5
}

last=""
printf 'watching %s for .scm/.bib/.json/.css changes (ctrl-c to stop)\n' "$PWD"
while :; do
    cur=$(fingerprint)
    if [ "$cur" != "$last" ]; then
        printf '%s  rebuilding... ' "$(date +%H:%M:%S)"
        if haunt build >/tmp/haunt-build.log 2>&1; then
            printf 'ok\n'
        else
            printf 'FAILED -- tail /tmp/haunt-build.log\n'
            tail -5 /tmp/haunt-build.log | sed 's/^/    /'
        fi
        last="$cur"
    fi
    sleep 1
done
