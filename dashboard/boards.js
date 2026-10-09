// ===================================================================
// YOUR PANELS. This file is yours; the dashboard page itself is the course's.
// One list per lesson; a panel is { title, view, render(el) }.
// render(el) fills the card's body, reading ONE view in `analysis`:
//   db.schema('analysis').from('<view>').select('*')
// The page shows numbers; the view does the counting.
// ===================================================================
const BOARDS = {
  example: [
    { title: 'Taps per screen', view: 'example_taps_per_screen', render: async (el) => {
        const { data, error } = await db.schema('analysis').from('example_taps_per_screen')
          .select('*').order('taps', { ascending: false });
        if (error) { el.innerHTML = '<p class="muted">Run <code>analysis/example_taps_per_screen.sql</code> in Supabase (SQL Editor) to see this example.</p>'; return; }
        el.innerHTML = `<div class="scroll"><table><thead><tr><th>app</th><th>screen</th><th>taps</th></tr></thead><tbody>${
          data.map(r => `<tr><td>${esc(r.app)}</td><td>${esc(r.screen)}</td><td class="num">${r.taps}</td></tr>`).join('')}</tbody></table></div>`;
      } }
  ],
  'unit-01': [
    { title: 'Replay a visit', view: 'visit_actions', render: async (el) => {
        el.innerHTML = `<p class="muted">Every visit, test runs and practice data included. Oldest first.
          The time is when the row arrived in the database, not when the person tapped: two quick actions can arrive in the wrong order.</p>
          <div class="row" style="margin:10px 0">
            <input id="rp-sid" placeholder="Paste a session_id" style="flex:1;min-width:260px">
            <button class="primary" id="rp-go">Replay</button>
          </div>
          <div class="row" style="margin-bottom:10px">
            <label class="muted">Action <select id="rp-action"><option value="">all</option>
              <option>click</option><option>selection</option><option>sign-in</option></select></label>
            <label class="muted">Screen <select id="rp-screen"><option value="">all</option></select></label>
          </div>
          <div class="scroll" id="rp-out"></div>`;
        const out = el.querySelector('#rp-out');
        const show = async (refreshScreens) => {
          const sid = el.querySelector('#rp-sid').value.trim();
          if (!sid) { out.innerHTML = ''; return; }
          const action = el.querySelector('#rp-action').value, screen = el.querySelector('#rp-screen').value;
          let q = db.schema('analysis').from('visit_actions').select('*').eq('session_id', sid);
          if (action) q = q.eq('action', action);
          if (screen) q = q.eq('screen', screen);
          const { data, error } = await q.order('n');
          if (error) { out.innerHTML = `<p class="muted">${error.code === '22P02' ? 'That is not a session_id.' : 'Run <code>analysis/visit_actions.sql</code> in Supabase (SQL Editor) first.'}</p>`; return; }
          if (refreshScreens) {
            const screens = [...new Set(data.map(r => r.screen).filter(Boolean))];
            el.querySelector('#rp-screen').innerHTML = '<option value="">all</option>' + screens.map(s => `<option>${esc(s)}</option>`).join('');
          }
          if (!data.length) { out.innerHTML = '<div class="empty">No actions for this visit.</div>'; return; }
          const v = x => x === null ? '<span class="muted">–</span>' : esc(x);
          out.innerHTML = `<table><thead><tr><th>#</th><th>time</th><th>action</th><th>screen</th><th>what happened</th><th>seq</th></tr></thead><tbody>${
            data.map(r => `<tr><td class="num">${r.n}</td><td>${esc(new Date(r.at).toLocaleTimeString([], { hour12: false }))}</td><td>${esc(r.action)}</td><td>${v(r.screen)}</td><td>${esc(r.what)}</td><td class="num">${v(r.seq)}</td></tr>`).join('')}</tbody></table>`;
        };
        el.querySelector('#rp-go').addEventListener('click', () => {
          el.querySelector('#rp-action').value = ''; el.querySelector('#rp-screen').value = ''; show(true);
        });
        el.querySelector('#rp-action').addEventListener('change', () => show(false));
        el.querySelector('#rp-screen').addEventListener('change', () => show(false));
      } }
  ],
  'unit-02': [
    { title: 'Who used the app?', view: 'usage_totals', render: async (el) => {
        const { data, error } = await db.schema('analysis').from('usage_totals').select('*');
        if (error || !data.length) { el.innerHTML = '<p class="muted">Run <code>analysis/usage_totals.sql</code> in Supabase (SQL Editor) to see this panel.</p>'; return; }
        const r = data[0];
        // One entry per number: its column in usage_totals, its definition, and what could make it wrong.
        const numbers = [
          { label: 'Visits', col: 'visits',
            def: 'We count every visit to the photo app, from sessions, excluding the team\'s own test runs, because those are not real visits and other apps\' rows are not ours.',
            wrong: 'If visits from other apps are not filtered out.' },
          { label: 'Browsers', col: 'browsers',
            def: 'We count different browsers, from the photo app\'s visits, excluding our own test runs.' },
          { label: 'People', col: 'people',
            def: 'We count different accounts from sign-ins, plus one person per browser that never signed in, from the photo app\'s visits, excluding our own test runs, because a browser that signed in on any visit is already counted by its account.' },
          { label: 'Came back (people)', col: 'came_back',
            def: 'We count the people (as in People) who had more than one visit, from the photo app\'s visits, excluding our own test runs.' },
          { label: 'Came back (% of People)', col: 'came_back_pct', suffix: '%',
            def: 'The people who came back, as a share of People.' },
          { label: 'Visits per person', col: 'visits_per_person',
            def: 'We divide Visits by People, both from the photo app\'s visits, excluding our own test runs.' }
        ];
        el.innerHTML = `<p class="muted">Population: the photo app only, practice data included, the team's own test runs excluded.</p>${
          numbers.map(n => `<div style="margin-top:14px">
            <div style="font-size:28px;font-weight:600">${esc(r[n.col])}${n.suffix || ''}</div>
            <div><b>${esc(n.label)}</b></div>
            <p class="muted" style="margin:2px 0">${esc(n.def)}</p>
            ${n.wrong ? `<p class="muted" style="margin:2px 0">Could be wrong: ${esc(n.wrong)}</p>` : ''}
          </div>`).join('')}`;
      } },
    { title: 'Visits with and without a click', view: 'visit_click_groups', own: true, render: async (el) => {
        const { data, error } = await db.schema('analysis').from('visit_click_groups').select('*').order('visit_group');
        if (error || !data.length) { el.innerHTML = '<p class="muted">This panel\'s view is not built yet.</p>'; return; }
        el.innerHTML = `<p class="muted">Population: the photo app only, practice data included, the team's own test runs excluded (as in Visits).</p>
          <p class="muted">We count visits from the photo app, split between visits with at least one click and visits with no click at all, because we want to find the visits without clicks.</p>${
          data.map(r => `<div style="margin-top:14px">
            <div style="font-size:28px;font-weight:600">${esc(r.visits)}</div>
            <div><b>Visits: ${esc(r.visit_group)}</b></div>
          </div>`).join('')}`;
      } },
    { title: 'Different accounts that signed in', view: 'account_totals', own: true, render: async (el) => {
        const { data, error } = await db.schema('analysis').from('account_totals').select('*');
        if (error || !data.length) { el.innerHTML = '<p class="muted">This panel\'s view is not built yet.</p>'; return; }
        el.innerHTML = `<p class="muted">Population: the entire identities table, every app, test runs and practice data included.</p>
          <div style="margin-top:14px">
            <div style="font-size:28px;font-weight:600">${esc(data[0].accounts)}</div>
            <div><b>Accounts</b></div>
            <p class="muted" style="margin:2px 0">We count different accounts that signed in, from the entire identities table, excluding nothing; an account that signed in more than once is counted once.</p>
          </div>`;
      } }
  ],
  'unit-08': []
};

