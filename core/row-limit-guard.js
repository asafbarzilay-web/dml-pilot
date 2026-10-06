// =====================================================================
// Row-limit guard. DO NOT EDIT. Load it before the dashboard creates its
// Supabase client.
//
// The database sends at most 1,000 rows per request. A dashboard that
// fetches raw rows and counts them in the page gets the first 1,000 and
// no error: the number is simply too small. This watches every read and
// puts a warning on the page when one comes back exactly at the limit.
// The fix is never a bigger limit: count in the database, in a view.
// =====================================================================
(function () {
  const LIMIT = 1000;
  const seen = new Set();
  const original = window.fetch.bind(window);

  window.fetch = async function (input, init) {
    const res = await original(input, init);
    try {
      const url = typeof input === 'string' ? input : input.url;
      const method = ((init && init.method) || (input && input.method) || 'GET').toUpperCase();
      if (method === 'GET' && url.includes('/rest/v1/') && res.ok) {
        // "0-999/*" or "0-999/3412": rows start-end, of total (if counted).
        const m = (res.headers.get('content-range') || '').match(/^(\d+)-(\d+)\/(\d+|\*)$/);
        if (m && Number(m[2]) - Number(m[1]) + 1 === LIMIT) warn(new URL(url).pathname.split('/').pop(), m[3]);
      }
    } catch (_) { /* the guard must never break a request */ }
    return res;
  };

  function warn(what, total) {
    console.warn(`[row limit] a read of "${what}" returned exactly ${LIMIT} rows${total !== '*' ? ` of ${total}` : ''}.`);
    if (seen.has(what)) return;
    seen.add(what);
    const show = () => {
      let bar = document.getElementById('row-limit-warning');
      if (!bar) {
        bar = document.createElement('div');
        bar.id = 'row-limit-warning';
        bar.style.cssText = 'position:sticky;top:0;z-index:1000;background:#FEF3F2;color:#7A271A;border-bottom:1px solid #FECDCA;padding:10px 20px;font:14px/1.5 -apple-system,BlinkMacSystemFont,system-ui,sans-serif';
        document.body.prepend(bar);
      }
      bar.innerHTML = `<strong>A number on this page is probably missing rows.</strong> A read of
        ${[...seen].map(s => `<code>${s.replace(/[<>&]/g, '')}</code>`).join(', ')} came back with exactly
        ${LIMIT.toLocaleString()} rows, the most the database sends at once. Anything counted from it in the
        page is too small. Count in the database instead, in a view.`;
    };
    document.body ? show() : document.addEventListener('DOMContentLoaded', show);
  }
})();
