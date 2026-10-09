# The course connection for scripts. DO NOT EDIT. Read by check-setup.sh and progress.sh.
COURSE_URL=$(sed -n "s/^const COURSE_URL = '\(.*\)';/\1/p" core/course-config.js)
COURSE_KEY=$(sed -n "s/^const COURSE_KEY = '\(.*\)';/\1/p" core/course-config.js)
SITE_ADDR=$(tr -d ' \n' < SITE)
STUDENT_ID=$(echo "$SITE_ADDR" | sed -n 's#^https*://\([^.]*\)\.github\.io/\([^/]*\).*#\1/\2#p')
STUDENT_NAME=$(tr -d '\n"\\' < STUDENT 2>/dev/null)
course_rpc() { curl -s -m 8 -X POST "$COURSE_URL/rest/v1/rpc/$1" -H "apikey: $COURSE_KEY" -H "Content-Type: application/json" -d "$2"; }
course_register() {
  [ -n "$STUDENT_ID" ] || { echo "(Not reported: SITE has no github.io address yet.)"; return 1; }
  course_rpc course_register "{\"p_student\":\"$STUDENT_ID\",\"p_name\":\"$STUDENT_NAME\",\"p_site\":\"$SITE_ADDR\"}" >/dev/null
}
course_lesson() { [ -n "$STUDENT_ID" ] && course_rpc course_my_lesson "{\"p_student\":\"$STUDENT_ID\"}"; }
