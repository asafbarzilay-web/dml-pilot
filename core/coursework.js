// =====================================================================
// Coursework. DO NOT EDIT.
//
// Checker answers and the memo, kept in the team's own database (table
// `coursework`, created by setup.sql), so every computer and the team's
// AI assistant see the same progress. Nothing is kept in the browser.
// Needs supabase-js and supabase-config.js loaded first.
// =====================================================================
const Coursework = (() => {
  // A copy whose database isn't filled in yet has no progress, and nothing to save it to.
  const unset = /YOUR-PROJECT/.test(SUPABASE_URL);
  const notConnected = () => Promise.reject(new Error('not connected to a database yet: finish the one-time setup'));

  // Never signs in and remembers nothing in the browser.
  const db = window.supabase.createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false, storageKey: 'coursework' }
  });

  // { q1: { answer, is_right, tries, submitted_at }, …, memo: {…} } for one lesson.
  async function load(lesson) {
    if (unset) return {};
    const { data, error } = await db.from('coursework').select('*').eq('lesson', lesson);
    if (error) throw error;
    return Object.fromEntries(data.map(r => [r.question, r]));
  }

  async function save(lesson, question, fields) {
    if (unset) return notConnected();
    const { error } = await db.from('coursework')
      .upsert({ lesson, question, ...fields, updated_at: new Date().toISOString() }, { onConflict: 'lesson,question' });
    if (error) throw error;
  }

  // Per lesson: how many answers are right, and whether the memo was submitted.
  async function summary() {
    if (unset) return {};
    const { data, error } = await db.from('coursework').select('lesson, question, is_right, submitted_at');
    if (error) throw error;
    const out = {};
    for (const r of data) {
      const l = out[r.lesson] = out[r.lesson] || { right: 0, memoSubmitted: false };
      if (r.question === 'memo') l.memoSubmitted = !!r.submitted_at;
      else if (r.is_right) l.right += 1;
    }
    return out;
  }

  // Progress from before it was kept in the database: move it in once, then forget it here.
  async function adoptBrowserCopy(lesson) {
    if (unset) return;
    let checker = null, memo = null;
    try { checker = JSON.parse(localStorage.getItem(`checker:${lesson}`)); memo = JSON.parse(localStorage.getItem(`memo:${lesson}`)); } catch {}
    if (!checker && !memo) return;
    for (const [q, s] of Object.entries(checker || {})) {
      await save(lesson, q, { answer: s.value || null, is_right: !!s.right, tries: s.tries || 0 });
    }
    if (memo) await save(lesson, 'memo', { answer: memo.text || '', submitted_at: memo.submitted || null });
    try { for (const k of [`checker:${lesson}`, `memo:${lesson}`, `progress:${lesson}`]) localStorage.removeItem(k); } catch {}
  }

  return { load, save, summary, adoptBrowserCopy };
})();
