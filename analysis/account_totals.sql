-- One row: how many different accounts signed in, from identities, without the team's test runs.
create or replace view analysis.account_totals as
  select count(distinct i.account) as accounts
  from public.identities i
  join public.sessions s on s.session_id = i.session_id
  where not s.is_test;

comment on view analysis.account_totals is
  'We count different accounts that signed in, from the identities table, excluding sign-ins made during the team''s own test runs (is_test in sessions); an account that signed in more than once is counted once.';
