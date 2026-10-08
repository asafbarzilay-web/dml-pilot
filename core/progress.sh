#!/bin/sh
# Prints the team's progress: one line per checker question and memo, from table coursework.
# DO NOT EDIT. Run it as: sh core/progress.sh
cd "$(dirname "$0")/.." || exit 1
URL=$(sed -n "s/^const SUPABASE_URL = '\(.*\)';/\1/p" supabase-config.js)
KEY=$(sed -n "s/^const SUPABASE_PUBLISHABLE_KEY = '\(.*\)';/\1/p" supabase-config.js)
echo "Current lesson: $(cat units/CURRENT)"
curl -s "$URL/rest/v1/coursework?select=lesson,question,is_right,submitted_at&order=lesson,question" -H "apikey: $KEY" \
  || echo "Could not reach the database."
echo
