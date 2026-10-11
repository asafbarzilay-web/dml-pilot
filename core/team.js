// =====================================================================
// The team's own files. DO NOT EDIT.
// <script src="core/team.js" data-file="supabase-config.js"></script> loads that file from the
// team's site: from the team's own address when the page is the course's central copy (see
// core/central.js), or from this same site otherwise. Always a fresh copy: the site lets browsers
// keep a file for 10 minutes, and rebuilds a minute after each save; either would hide a panel
// the assistant just published.
// =====================================================================
(function () {
  var me = document.currentScript, file = me.getAttribute('data-file');
  var team = window.COURSE_TEAM;
  var src = team ? team.base + file : new URL('../' + file, me.src).href;
  src += (src.indexOf('?') < 0 ? '?' : '&') + 'v=' + Date.now();
  // Straight from the team's repository first: it has the file seconds after the assistant saves,
  // while the site takes about a minute to rebuild. If that fails, the site's copy as before.
  var repo = team && team.site;
  if (!repo) { var m = location.hostname.match(/^([^.]+)\.github\.io$/), seg = location.pathname.split('/')[1];
    if (m && seg) repo = m[1] + '/' + seg; }
  if (repo) {
    try {
      var x = new XMLHttpRequest();
      x.open('GET', 'https://raw.githubusercontent.com/' + repo + '/main/' + file + '?v=' + Date.now(), false);
      x.send();
      if (x.status === 200 && x.responseText) {
        document.write('<script>' + x.responseText.replace(/<\/script/gi, '<\\/script') + '\n<\/script>');
        return;
      }
    } catch (e) {}
  }
  document.write('<script src="' + src.replace(/"/g, '') + '"><\/script>');
})();
