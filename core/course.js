// =====================================================================
// The course connection. DO NOT EDIT.
// Reports setup, checker tries and memos to the lecturer, and asks which
// lesson this student is on (the lecturer sets it; units/CURRENT is the
// fallback when the course can't be reached).
// Needs supabase-js and core/course-config.js loaded first.
// =====================================================================
const Course = (() => {
  const db = window.supabase.createClient(COURSE_URL, COURSE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false, storageKey: 'course' }
  });
  const root = (() => { const p = location.pathname; const i = p.search(/\/(units|checker|dashboard|data|slides)\//); return i >= 0 ? p.slice(0, i + 1) : p.replace(/[^/]*$/, ''); })();

  // Who this is: 'github-name/repository', from the site's address (or the SITE file when run locally).
  let who = null;
  async function student() {
    if (who) return who;
    let site = location.hostname.endsWith('github.io') ? location.origin + root : '';
    if (!site) site = (await fetch(root + 'SITE', { cache: 'no-store' }).then(r => r.ok ? r.text() : '').catch(() => '')).trim();
    const m = site.match(/^https?:\/\/([^.]+)\.github\.io\/([^/]+)/);
    return (who = m ? `${m[1]}/${m[2]}` : null);
  }
  const call = (fn, args) => Promise.race([
    db.rpc(fn, args).then(({ data, error }) => { if (error) throw error; return data; }),
    new Promise((_, no) => setTimeout(() => no(new Error('the course did not answer')), 4000))]);

  // { lesson: 'unit-02', since: '…' }. Falls back to units/CURRENT.
  async function lesson() {
    try {
      const s = await student();
      if (s) { const r = await call('course_my_lesson', { p_student: s }); if (r && r.lesson) return r; }
    } catch {}
    const cur = (await fetch(root + 'units/CURRENT', { cache: 'no-store' }).then(r => r.ok ? r.text() : '').catch(() => '')).trim();
    return { lesson: cur, since: null };
  }
  // Reports never block the student: if the course can't be reached, the page carries on.
  async function attempt(lessonId, question, answer, right) {
    const s = await student(); if (!s) return;
    call('course_record_attempt', { p_student: s, p_lesson: lessonId, p_question: question, p_answer: answer, p_right: right }).catch(() => {});
  }
  async function memo(lessonId, text, submittedAt) {
    const s = await student(); if (!s) return;
    call('course_save_memo', { p_student: s, p_lesson: lessonId, p_text: text, p_submitted: submittedAt }).catch(() => {});
  }
  return { student, lesson, attempt, memo };
})();
