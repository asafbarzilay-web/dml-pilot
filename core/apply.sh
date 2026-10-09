#!/bin/sh
# Builds the team's analysis in their database: sends each file in analysis/ to it. DO NOT EDIT.
# Run it as: sh core/apply.sh                 (every file in analysis/)
#        or: sh core/apply.sh analysis/x.sql  (just those)
# Needs SUPABASE_SECRET_KEY in the Claude cloud environment (setup step 8). Never prints the key.
cd "$(dirname "$0")/.." || exit 1
URL=$(sed -n "s/^const SUPABASE_URL = '\(.*\)';/\1/p" supabase-config.js)
case "$URL" in *YOUR-*|"") echo "NOT CONNECTED: supabase-config.js still has the placeholders (setup step 9)."; exit 1;; esac
[ -n "$SUPABASE_SECRET_KEY" ] || { echo "NO KEY: this environment has no SUPABASE_SECRET_KEY. Add it to the cloud environment (setup step 8), then start a new session."; exit 1; }

files="$*"; [ -n "$files" ] || files=$(ls analysis/*.sql 2>/dev/null)
[ -n "$files" ] || { echo "Nothing to build: analysis/ has no .sql files."; exit 0; }

send() {   # $1 = file; prints the HTTP status, then the answer
  python3 -c 'import json,sys;print(json.dumps({"p_sql":open(sys.argv[1]).read()}))' "$1" |
    curl -s -w '\n%{http_code}' -X POST "$URL/rest/v1/rpc/analysis_apply" \
      -H "apikey: $SUPABASE_SECRET_KEY" -H "Authorization: Bearer $SUPABASE_SECRET_KEY" \
      -H "Content-Type: application/json" --data-binary @-
}
# A view built on another view needs that one first: keep passing over what failed while it helps.
left="$files"
while [ -n "$left" ]; do
  failed=""
  for f in $left; do
    code=$(send "$f" | tail -1)
    case "$code" in 200) echo "OK   $f";;
      401|403) echo "FAIL the secret key was refused: check SUPABASE_SECRET_KEY in the cloud environment (setup step 8)."; exit 1;;
      404) echo "FAIL your database has no analysis_apply: run the setup again (setup step 5)."; exit 1;;
      *) failed="$failed $f";; esac
  done
  [ "$failed" = "$left" ] && break
  left=$failed
done
[ -z "$left" ] && { echo "ALL BUILT"; exit 0; }
for f in $left; do
  echo "FAIL $f: $(send "$f" | sed '$d' | python3 -c 'import json,sys
try: print(json.load(sys.stdin).get("message", "unknown error"))
except Exception: print("unknown error")')"
done
exit 1
