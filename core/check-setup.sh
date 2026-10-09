#!/bin/sh
# Checks the one-time setup from here, without a password. DO NOT EDIT.
# Run it as: sh core/check-setup.sh
cd "$(dirname "$0")/.." || exit 1
URL=$(sed -n "s/^const SUPABASE_URL = '\(.*\)';/\1/p" supabase-config.js)
KEY=$(sed -n "s/^const SUPABASE_PUBLISHABLE_KEY = '\(.*\)';/\1/p" supabase-config.js)
case "$URL$KEY" in *YOUR-*) echo "NOT CONNECTED: supabase-config.js still has the placeholders (setup step 9)."; exit 1;; esac
H1="apikey: $KEY"; H2="Content-Type: application/json"
newid() { python3 -c 'import uuid;print(uuid.uuid4())' 2>/dev/null || cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen | tr A-Z a-z; }
ok=1

# 0. The address and key work at all: a wrong one makes every other check meaningless.
code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$URL/rest/v1/rpc/capture_arrived" -H "$H1" -H "$H2" -d '{}' 2>/dev/null)
case "$code" in 000) echo "FAIL connection: the project URL in supabase-config.js can't be reached (step 9)."; exit 1;;
  401|403) echo "FAIL connection: the publishable key in supabase-config.js is wrong (step 9)."; exit 1;; esac
echo "OK   connection: project URL and key work (step 9)"

# 1. The database setup ran: the check function exists and answers.
r=$(curl -s -X POST "$URL/rest/v1/rpc/capture_arrived" -H "$H1" -H "$H2" -d "{\"sid\":\"$(newid)\"}")
case "$r" in false) echo "OK   database setup (step 5)";;
  *) echo "FAIL database setup (step 5): run the setup again in Supabase's SQL Editor."; ok=0;; esac

# 2. The analysis space is exposed: the database must not answer "schema must be one of".
r=$(curl -s "$URL/rest/v1/nothing_here?select=*" -H "$H1" -H "Accept-Profile: analysis")
case "$r" in *PGRST106*) echo "FAIL exposed schemas (step 7): add analysis under Project Settings > Data API."; ok=0;;
  *) echo "OK   analysis is exposed (step 7)";; esac

# 3. Capture: write a test visit and a click as the app does, then confirm both arrived.
[ $ok = 0 ] && { echo "SKIP capture: fix the setup above first."; exit 1; }
sid=$(newid)
curl -s -o /dev/null -X POST "$URL/rest/v1/sessions" -H "$H1" -H "$H2" \
  -d "{\"session_id\":\"$sid\",\"user_id\":\"$(newid)\",\"app\":\"health-check\",\"platform\":\"desktop\",\"is_test\":true}"
curl -s -o /dev/null -X POST "$URL/rest/v1/clicks" -H "$H1" -H "$H2" \
  -d "{\"session_id\":\"$sid\",\"step\":\"health\",\"x\":0.5,\"y\":0.5,\"seq\":1,\"hit\":\"none\"}"
r=$(curl -s -X POST "$URL/rest/v1/rpc/capture_arrived" -H "$H1" -H "$H2" -d "{\"sid\":\"$sid\"}")
case "$r" in true) echo "OK   capture works: a test visit and click were written and found (marked as a test)";;
  *) echo "FAIL capture: the test visit was not found. Check the URL and key in supabase-config.js."; ok=0;; esac

[ $ok = 1 ] || exit 1
echo "ALL GOOD"

# Tell the lecturer this student is set up (once; again is harmless).
. ./core/course.sh 2>/dev/null && course_register && echo "Reported to your lecturer: setup done."
