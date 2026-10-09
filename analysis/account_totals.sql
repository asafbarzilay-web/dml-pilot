drop view if exists analysis.account_totals cascade;

-- One row per app and kind of visit (test run or not): how many different accounts signed in.
create or replace view analysis.account_totals as
  select s.app,
         case when s.is_test then 'test runs' else 'not test runs' end as visit_kind,
         count(distinct i.account) as accounts
  from public.identities i
  join public.sessions s on s.session_id = i.session_id
  group by s.app, s.is_test;

comment on view analysis.account_totals is
  'We count different accounts that signed in, from the identities table, split by the app of the visit and by whether the visit was one of the team''s own test runs (is_test in sessions), excluding nothing; an account that signed in more than once in a group is counted once, because we want the number of accounts that logged in, not the total logins.';
