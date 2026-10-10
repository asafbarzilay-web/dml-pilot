// =====================================================================
// The team's own files. DO NOT EDIT.
// <script src="core/team.js" data-file="supabase-config.js"></script> loads that file from the
// team's site: from the team's own address when the page is the course's central copy (see
// core/central.js), or from this same site otherwise.
// =====================================================================
(function () {
  var me = document.currentScript, file = me.getAttribute('data-file');
  var team = window.COURSE_TEAM;
  var src = team ? team.base + file : new URL('../' + file, me.src).href;
  document.write('<script src="' + src.replace(/"/g, '') + '"><\/script>');
})();
