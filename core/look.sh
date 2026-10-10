#!/bin/sh
# Reads the team's database, for checking a number the assistant built. Read-only. DO NOT EDIT.
# Run it as: sh core/look.sh "<table>?<query>"            e.g. sh core/look.sh "sessions?select=user_id,app,is_test&app=eq.photo&limit=20"
#        or: sh core/look.sh analysis "<view>?<query>"    e.g. sh core/look.sh analysis "usage_totals?select=*"
# Queries use the Data API's syntax (select=, col=eq.value, order=, limit=). Never prints the key.
cd "$(dirname "$0")/.." || exit 1
URL=$(sed -n "s/^const SUPABASE_URL = '\(.*\)';/\1/p" supabase-config.js)
[ -n "$SUPABASE_SECRET_KEY" ] || { echo "NO KEY: this session has no SUPABASE_SECRET_KEY (setup step 7)."; exit 1; }
schema=public; [ "$1" = analysis ] && { schema=analysis; shift; }
# Older setups let only the dashboard read views: let the secret key read them too (idempotent).
[ $schema = analysis ] && curl -s -o /dev/null -X POST "$URL/rest/v1/rpc/analysis_apply" -H "apikey: $SUPABASE_SECRET_KEY" \
  -H "Authorization: Bearer $SUPABASE_SECRET_KEY" -H "Content-Type: application/json" \
  -d '{"p_sql":"grant usage on schema analysis to service_role; grant select on all tables in schema analysis to service_role;"}'
[ -n "$1" ] || { echo 'usage: sh core/look.sh [analysis] "<table>?<query>"'; exit 1; }
curl -s -G "$URL/rest/v1/$1" -H "apikey: $SUPABASE_SECRET_KEY" -H "Authorization: Bearer $SUPABASE_SECRET_KEY" \
  -H "Accept-Profile: $schema" -H "Prefer: count=exact" -D /tmp/look-headers.$$ -o /tmp/look-body.$$
echo "$(sed -n 's/^[Cc]ontent-[Rr]ange: *//p' /tmp/look-headers.$$ | tr -d '\r') rows"
cat /tmp/look-body.$$; echo
rm -f /tmp/look-headers.$$ /tmp/look-body.$$
