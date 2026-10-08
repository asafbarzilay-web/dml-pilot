-- The replay of one visit: every click, selection and sign-in, one per row.
-- What could make it wrong: the time is when the row arrived in the database,
-- not when the person tapped. Two quick actions can arrive in the wrong order.
create or replace view analysis.visit_actions as
  select
    session_id,
    row_number() over (partition by session_id order by at, seq nulls last) as n,
    at, action, screen, what, overlay, hit, seq, x, y, value, duration_ms, account
  from (
    select session_id, created_at as at, 'click' as action, step as screen,
           'tapped ' || hit || coalesce(' (over ' || overlay || ')', '') as what,
           overlay, hit, seq, x, y,
           null::text as value, null::integer as duration_ms, null::text as account
    from public.clicks
    union all
    select session_id, created_at, 'selection', step,
           'chose ' || value || ' after ' || round(duration_ms / 1000.0, 1) || ' s',
           null, null, null, null, null,
           value, duration_ms, null
    from public.selections
    union all
    select session_id, created_at, 'sign-in', null,
           'signed in as account ' || account,
           null, null, null, null, null,
           null, null, account
    from public.identities
  ) a;

comment on view analysis.visit_actions is
  'One row is one action in a visit: a click, a selection or a sign-in, from clicks, selections and identities, for every visit including test runs and practice data, excluding nothing. Read it oldest first (n = 1 is the first action).';
