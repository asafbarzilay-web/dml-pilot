#!/bin/sh
# Applies a reset your lecturer made: clears one lesson's saved answers, panels and views, as if it was never
# started, and saves. DO NOT EDIT. Run it as: sh core/reset-lesson.sh <lesson> <id>   e.g. sh core/reset-lesson.sh lesson-04 7
# (<lesson> and <id> are on the "RESET PENDING" line of core/progress.sh; only a pending reset runs.)
# Needs SUPABASE_SECRET_KEY in the Claude cloud environment. Never prints the key.
cd "$(dirname "$0")/.." || exit 1
LESSON=$1; ID=$2
[ -n "$ID" ] || { echo 'usage: sh core/reset-lesson.sh <lesson> <id>   (from "RESET PENDING" in core/progress.sh)'; exit 1; }
URL=$(sed -n "s/^const SUPABASE_URL = '\(.*\)';/\1/p" supabase-config.js)
[ -n "$SUPABASE_SECRET_KEY" ] || { echo "NO KEY: this session has no SUPABASE_SECRET_KEY (setup step 7)."; exit 1; }
. ./core/course.sh
PENDING=$(course_rpc course_pending_resets "{\"p_student\":\"$STUDENT_ID\"}")
python3 - "$LESSON" "$ID" "$URL" "$PENDING" <<'PY' || exit 1
import json, os, re, sys, urllib.request
lesson, rid, url, pending = sys.argv[1:5]
key = os.environ["SUPABASE_SECRET_KEY"]
H = {"apikey": key, "Authorization": "Bearer " + key, "Content-Type": "application/json"}

def call(method, path, body=None, extra=None):
    req = urllib.request.Request(url + path, None if body is None else json.dumps(body).encode(), {**H, **(extra or {})}, method=method)
    try:
        with urllib.request.urlopen(req, timeout=30) as r: return r.status, r.read().decode()
    except urllib.error.HTTPError as e: return e.code, e.read().decode()

# Only a reset the lecturer really made for this team.
try: ok = any(str(r["id"]) == rid and r["lesson"] == lesson for r in json.loads(pending))
except Exception: ok = False
if not ok: print("NOT DONE: no pending reset %s for %s from your lecturer." % (rid, lesson)); sys.exit(1)

lessons = json.load(open("units/lessons.json"))
info = next((l for l in lessons if l.get("checker") == lesson), None)
if not info: print("NOT DONE: unknown lesson " + lesson); sys.exit(1)
unit, data_id = info["unit"], info.get("data")

# 1 · the saved answers, memo and tries of this lesson, and the "practice data loaded" mark if it was this lesson's.
call("DELETE", "/rest/v1/coursework?lesson=eq." + lesson)
s, t = call("GET", "/rest/v1/coursework?select=answer&lesson=eq.practice-data&question=eq.loaded")
try:
    if data_id and json.loads(t)[0]["answer"] == data_id: call("DELETE", "/rest/v1/coursework?lesson=eq.practice-data&question=eq.loaded")
except Exception: pass
print("Cleared the saved answers and memo of %s." % lesson)

# 2 · the lesson's board: its panels out of dashboard/boards.js
def list_span(src, k):
    m = re.search(r"['\"]%s['\"]\s*:\s*\[" % re.escape(k), src)
    if not m: return None
    i = m.end() - 1; j = i; depth = 0; n = len(src)
    while j < n:
        c = src[j]
        if c in "'\"`":
            q = c; j += 1
            while j < n and src[j] != q:
                if src[j] == "\\": j += 1
                elif q == "`" and src[j:j+2] == "${":
                    d = 1; j += 2
                    while j < n and d:
                        if src[j] == "{": d += 1
                        elif src[j] == "}": d -= 1
                        j += 1
                    continue
                j += 1
        elif src[j:j+2] == "//":
            j = src.find("\n", j); j = n if j < 0 else j; continue
        elif src[j:j+2] == "/*":
            j = src.find("*/", j) + 1
        elif c == "[": depth += 1
        elif c == "]":
            depth -= 1
            if depth == 0: return i, j + 1
        j += 1
    return None

path = "dashboard/boards.js"; src = open(path).read()
span = list_span(src, unit); views = []; new = src
if span is None:
    print("No board for %s in %s: no panels to remove." % (unit, path))
else:
    views = re.findall(r"view:\s*['\"]([A-Za-z0-9_]+)['\"]", src[span[0]:span[1]])
    new = src[:span[0]] + "[]" + src[span[1]:]
    if list_span(new, unit) != (span[0], span[0] + 2): print("NOT DONE: boards.js did not come out right; nothing was changed."); sys.exit(1)
    open(path, "w").write(new)
    print("Removed the panels of the %s board (%d view(s) were shown on it)." % (unit, len(set(views))))

# 3 · their views: dropped unless another lesson's board still shows them or another view is built on them
keep = set(re.findall(r"view:\s*['\"]([A-Za-z0-9_]+)['\"]", new))
todo = [v for v in dict.fromkeys(views) if v not in keep]
for v in views:
    if v in keep: print("Kept view %s: another lesson's board uses it." % v)
dropped, left = [], list(todo)
while left:
    progress = False
    for v in list(left):
        st, _ = call("POST", "/rest/v1/rpc/analysis_apply", {"p_sql": "drop view if exists analysis.%s" % v})
        if st == 200:
            left.remove(v); dropped.append(v); progress = True
            f = "analysis/%s.sql" % v
            if os.path.exists(f): os.remove(f)
    if not progress: break
for v in left: print("Kept view %s: another view is built on it." % v)
if dropped: print("Dropped the views: " + ", ".join(dropped) + ".")

# 4 · note it is done, so it never runs twice
call("POST", "/rest/v1/coursework", [{"lesson": "practice-data", "question": "reset:" + rid, "answer": "applied"},
                                     {"lesson": "practice-data", "question": "resetwork:" + rid, "answer": "applied"}],
     {"Prefer": "resolution=merge-duplicates"})
print("RESET DONE: %s starts fresh." % lesson)
PY
sh core/save.sh "Reset $LESSON as the lecturer asked"
